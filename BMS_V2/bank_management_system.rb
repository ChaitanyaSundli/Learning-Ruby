require_relative 'modals/account'
require_relative 'modals/bank'
require_relative 'modals/customer'
require_relative 'modals/transaction'
require 'tty-table'
require 'tty-prompt'
require "./modules/session"
require "./modules/validators"
require "./modules/utility"

class BankManagementSystem

  include Validators
  include Utility

  attr_accessor :list_of_bank, :list_of_customer, :list_of_transaction, :session

  def initialize

    @list_of_bank = []
    @list_of_customer = []
    @list_of_transaction = []

    @accounts_by_id = {}
    @session = Session.new
    @prompt = TTY::Prompt.new

  end


  def create_bank

    print "Bank name: "
    name = gets.chomp
    treasury = positive_input("Treasury: ")
    emi = positive_input("EMI rate: ")
    loan = positive_input("Loan rate: ")
    pass = password_validator("Bank PIN: ")

    bank = Bank.new(name, treasury, emi, loan, pass)

    @list_of_bank << bank

  end

  def create_account

  require_bank_management

  print "Customer ID: "
  cid = gets.to_i
  customer = @list_of_customer.find { |c| c.id == cid }

  raise "Customer not found" unless customer

    puts "\nAvailable Banks"

    @list_of_bank.each do |b|
      puts "#{b.id}. #{b.name}"
    end

    print "Select Bank ID: "
    bank_id = gets.chomp.to_i

    bank = @list_of_bank.find { |b| b.id == bank_id }

    raise "Invalid bank selected" unless bank

    acc = Bank.create_account(bank, customer)

    @accounts_by_id[acc.id] = acc

    if acc.is_a?(LoanAccount)
      record_transaction(nil, acc.id, acc.loan_amt, "LOAN_DISBURSE")
    end

    puts "\nAccount created successfully!"
    puts "Account ID: #{acc.id}"
    puts "Bank: #{bank.name}"
    puts "Owner: #{customer.name}"

  end

  def register_user
    name = name_validator("Name: ")
    pass = password_validator("PIN: ")
    print "Phone: "
    phone = gets.chomp
    phone = phone_validator(phone, @list_of_customer)
    user = Customer.new(name, pass, phone)
    @list_of_customer << user
    puts "\nUser created successfully"
    puts "Your Customer ID is: #{user.id}"
  end  

  def view_bank_accounts

    if @session.role == :admin
      bank = @session.current_user
      accounts = bank.list_of_account
    elsif @session.role == :bank_management
      accounts = @accounts_by_id.values
    else
      raise "Permission denied"
    end

    rows = accounts.map do |acc|
      balance = acc.respond_to?(:balance) ? acc.balance : acc.total_amt_to_pay

      [
        acc.bank.name,
        acc.id,
        acc.customer.name,
        acc.class.name,
        balance
      ]
    end

    table = TTY::Table.new(
      ["Bank","AccountID","Customer","Type","Balance/Loan"],
      rows
    )

    puts table.render(:unicode)

  end

  def view_my_accounts
    require_customer
    accounts = @session.current_user.list_of_account.select(&:is_active)
    raise "No accounts found" if accounts.empty?
    rows = accounts.map do |a|
      [a.id, a.class.name, (a.respond_to?(:balance) ? a.balance : a.total_amt_to_pay)]
    end
    puts TTY::Table.new(["ID","Type","Balance"], rows).render(:unicode)
  end

  def deposit_money
    require_customer
    accounts = @session.current_user.list_of_account
      .select { |a| a.is_a?(SavingsAccount) || a.is_a?(CurrentAccount) }
    acc = choose_account(accounts)
    amt = positive_input("Amount: ")
    verify_account_pin(acc)
    acc.deposit(self, amt)
  end

  def withdraw_money
    require_customer
    accounts = @session.current_user.list_of_account
      .select { |a| a.is_a?(SavingsAccount) || a.is_a?(CurrentAccount) }

    acc = choose_account(accounts)
    amt = positive_input("Amount: ")
    verify_account_pin(acc)
    acc.withdraw(self, amt)
  end

  def transfer_btw_accs
    require_customer
    sender_accounts = @session.current_user.list_of_account
      .select { |a| a.is_a?(SavingsAccount) || a.is_a?(CurrentAccount) }

    sender = choose_account(sender_accounts)
    amt = positive_input("Transfer amount: ")
    verify_account_pin(sender)
    puts "\nReceiver Accounts"
    rows = @accounts_by_id.values.map { |a| [a.id, a.customer.name] }
    puts TTY::Table.new(["ID","Owner"], rows).render(:unicode)
    print "Receiver Account ID: "
    rid = gets.chomp.to_i
    receiver = @accounts_by_id[rid]
    raise "Receiver not found" unless receiver

    Bank.transfer(sender, receiver, amt, @list_of_transaction)

  end

  def view_loans
    @accounts_by_id.values
      .select { |a| a.is_a?(LoanAccount) }
      .each { |l| puts l }
  end

  def repay_loan
    require_customer
    customer = @session.current_user
    loans = customer.list_of_account.select { |a| a.is_a?(LoanAccount) && a.is_active }

    raise "No active loan accounts" if loans.empty?

    rows = loans.map { |l| [l.id, l.bank.name, l.total_amt_to_pay] }
    puts TTY::Table.new(["Loan ID", "Bank", "Remaining"], rows).render(:unicode)
    
    print "Select Loan ID: "
    id = gets.chomp.to_i
    loan = loans.find { |l| l.id == id }
    raise "Invalid loan selected" unless loan

    if loan.is_emi
      amt = loan.emi
      puts "Fixed EMI Amount: #{amt}"
    else
      amt = positive_input("Repay amount: ")
    end

    raise "Repay amount exceeds remaining loan" if amt > loan.total_amt_to_pay
    
    print "Enter Loan PIN: "
    raise "Incorrect PIN" unless gets.chomp == loan.password.to_s

    loan.total_amt_to_pay -= amt
    loan.bank.treasury += amt
    record_transaction(customer.id, loan.id, amt, "LOAN_REPAY")

    if loan.total_amt_to_pay <= 0
      loan.is_active = false
      puts "Loan fully repaid. Account closed."
    else
      puts "Repayment successful. Remaining: #{loan.total_amt_to_pay}"
      puts "EMIs remaining: #{EMIEngine.emis_remaining(loan.emi, loan.total_amt_to_pay)}" if loan.is_emi
    end
  end

  def close_loan_account
    customer = get_item_from_list("Customer ID: ", @list_of_customer)
    loan = customer.list_of_account.find { |a| a.is_a?(LoanAccount) }
    raise "Loan remaining" unless loan.total_amt_to_pay <= 0

    loan.is_active = false
  end

  def login

    puts "\nLogin as:"
    puts "1 Customer"
    puts "2 Bank Admin"
    puts "3 Bank Management"

    type = gets.to_i

    case type

    when 1
      id = positive_input("Customer ID: ").to_i
      user = @list_of_customer.find { |u| u.id == id }
      raise "User not found" unless user

      print "PIN: "
      pass = gets.chomp
      raise "Incorrect PIN" unless pass == user.password.to_s

      @session.current_user = user
      @session.role = :customer

    when 2
      puts "\nAvailable Banks"
      @list_of_bank.each { |b| puts "#{b.id}. #{b.name}" }

      print "Select Bank ID: "
      id = gets.to_i

      bank = @list_of_bank.find { |b| b.id == id }
      raise "Invalid bank" unless bank

      print "Admin PIN: "
      pass = gets.chomp

      raise "Invalid admin PIN" unless pass == bank.instance_variable_get(:@password).to_s

      @session.current_user = bank
      @session.role = :admin

    when 3
      print "Management PIN: "
      pass = gets.chomp

      raise "Invalid management PIN" unless pass == "9999"

      @session.current_user = "BANK_MANAGEMENT"
      @session.role = :bank_management

    else
      raise "Invalid option"
    end

  end

  def logout
    @session.logout
    puts "Logged out successfully"
  end

  def require_customer
    raise "Customer login required" unless @session.role == :customer
  end

  def require_admin
    raise "Admin login required" unless @session.role == :admin
  end

  def select_bank_admin

    puts "\nAvailable Banks"

    @list_of_bank.each { |b| puts "#{b.id}. #{b.name}" }

    print "Select Bank ID: "
    id = gets.to_i

    bank = @list_of_bank.find { |b| b.id == id }

    raise "Invalid bank" unless bank

    print "Admin PIN: "
    pass = gets.chomp

    raise "Invalid admin PIN" unless pass == bank.instance_variable_get(:@password).to_s

    @session.current_user = bank
    @session.role = :admin

  end

  def select_bank_management

    puts "\nAvailable Banks"

    @list_of_bank.each { |b| puts "#{b.id}. #{b.name}" }

    print "Select Bank ID: "
    id = gets.to_i

    bank = @list_of_bank.find { |b| b.id == id }

    raise "Invalid bank" unless bank

    print "Management PIN: "
    pass = gets.chomp

    raise "Invalid PIN" unless pass == bank.instance_variable_get(:@password).to_s

    @session.current_user = bank
    @session.role = :bank_management

  end

  def require_bank_management
    raise "Bank management login required" unless @session.role == :bank_management
  end


  def choose_account(accounts)

    rows = accounts.map do |acc|
      [acc.id, acc.class.name, acc.respond_to?(:balance) ? acc.balance : acc.total_amt_to_pay]
    end

    table = TTY::Table.new(["Account ID","Type","Balance/Loan"], rows)
    puts table.render(:unicode)

    loop do
      print "Select Account ID: "
      id = gets.chomp.to_i
      acc = accounts.find { |a| a.id == id }
      return acc if acc

      puts "Invalid account ID. Try again."
    end
  end

  def verify_account_pin(account)
    print "Enter Account PIN: "
    pin = gets.chomp

    raise "Incorrect PIN" unless pin == account.password.to_s
  end

  def record_transaction(from, to, amount, type)
    txn = Transaction.new(from, to, amount, type)
    @list_of_transaction << txn
    txn.complete!("SUCCESS")
  end

  def view_transactions
    raise "Login required" unless @session.logged_in?

    if @session.role == :customer
      view_customer_transactions
    else
      view_admin_transactions
    end
  end

  def view_customer_transactions
    customer = @session.current_user
    account_ids = customer.list_of_account.map(&:id)
    txns = @list_of_transaction.select do |t|
      account_ids.include?(t.from) || account_ids.include?(t.to)
    end
    show_transaction_table(txns)
  end

  def view_admin_transactions

    if @session.role == :admin
      bank = @session.current_user
      account_ids = bank.list_of_account.map(&:id)

      txns = @list_of_transaction.select do |t|
        account_ids.include?(t.from) || account_ids.include?(t.to)
      end

    elsif @session.role == :bank_management
      txns = @list_of_transaction
    else
      raise "Permission denied"
    end

    show_transaction_table(txns)

  end

  def show_transaction_table(transactions)
    rows = transactions.map do |t|
      acc_id = t.from || t.to
      account = @accounts_by_id[acc_id]
      bank_name = account&.bank&.name || "N/A"
      [
        t.id,
        bank_name,
        t.type,
        t.from,
        t.to,
        t.amount,
        t.time.strftime("%d-%m-%Y %H:%M"),
        t.status
      ]
    end

    table = TTY::Table.new(
      ["ID","Bank","Type","From","To","Amount","Created At","Status"],
      rows
    )
    puts table.render(:unicode)
  end

  def risky_loans
    loans = @accounts_by_id.values.select { |a| a.is_a?(LoanAccount) }
    rows = []
    loans.each do |loan|
      customer = loan.customer
      total_balance = customer.list_of_account
        .select { |a| a.respond_to?(:balance) }
        .sum { |a| a.balance }

      if loan.total_amt_to_pay > 5 * total_balance
        rows << [loan.id, customer.name, loan.total_amt_to_pay, total_balance]
      end
    end

    if rows.empty?
      puts "No risky loans found"
      return
    end

    table = TTY::Table.new(
      ["Loan ID","Customer","Loan Amount","Customer Balance"],
      rows
    )
    puts table.render(:unicode)
  end

  def risky_customers

    rows = []

    @list_of_customer.each do |customer|

      active_accounts = customer.list_of_account.select(&:is_active)

      current_accounts = active_accounts.select { |a| a.is_a?(CurrentAccount) }
      savings_accounts = active_accounts.select { |a| a.is_a?(SavingsAccount) }

      next if current_accounts.empty?

      savings_balance = savings_accounts.sum { |a| a.balance }

      total_negative_current = current_accounts
        .select { |a| a.balance < 0 }
        .sum { |a| a.balance }

      next if total_negative_current >= 0

      if savings_balance + total_negative_current < 0
        rows << [
          customer.id,
          customer.name,
          total_negative_current,
          savings_balance
        ]
      end

    end

    if rows.empty?
      puts "No risky customers found"
      return
    end

    table = TTY::Table.new(
      ["Customer ID","Name","Total Current Balance","Total Savings Balance"],
      rows
    )

    puts table.render(:unicode)

  end
  
  def loan_tenure_reduction

    loans = @accounts_by_id.values.select { |a| a.is_a?(LoanAccount) && a.is_active }

    raise "No active loan accounts found" if loans.empty?

    rows = loans.map do |loan|
      [loan.id, loan.customer.name, loan.total_amt_to_pay, loan.bank.name]
    end

    table = TTY::Table.new(["Loan ID","Customer","Principal","Bank"], rows)
    puts table.render(:unicode)

    print "Select Loan ID: "
    id = gets.chomp.to_i

    loan = loans.find { |l| l.id == id }

    raise "Invalid loan selected" unless loan

    prepay = positive_input("One-time principal payment: ")

    bank = loan.bank
    rate = bank.EMI_RATE
    principal = loan.total_amt_to_pay

    years = 5
    months = years * 12
    r = rate / (12.0 * 100)

    emi = EMIEngine.calculate(principal, rate, years)

    current_n = Math.log(emi / (emi - principal * r)) / Math.log(1 + r)

    new_principal = principal - prepay

    raise "Prepayment exceeds principal" if new_principal <= 0

    new_n = Math.log(emi / (emi - new_principal * r)) / Math.log(1 + r)

    months_saved = (current_n - new_n).round

    puts
    puts "Loan ID: #{loan.id}"
    puts "Customer: #{loan.customer.name}"
    puts "Current Principal: #{principal}"
    puts "Prepayment: #{prepay}"
    puts "Months Saved: #{months_saved}"

  end

  def bank_profit

    rows = []

    @list_of_bank.each do |bank|

      account_ids = bank.list_of_account.map(&:id)

      income = @list_of_transaction
        .select do |t|
          account_ids.include?(t.to) &&
          ["LOAN_REPAY","INTEREST"].include?(t.type)
        end
        .sum { |t| t.amount }

      rows << [bank.id, bank.name, income]

    end

    table = TTY::Table.new(
      ["Bank ID","Bank","Profit"],
      rows
    )

    puts table.render(:unicode)

  end

  def seed_dummy_data

    c1 = Customer.new("Rahul Sharma",1234,"9876543210")
    c2 = Customer.new("Priya Mehta",1234,"9876543211")
    c3 = Customer.new("Amit Patel",1234,"9876543212")
    c4 = Customer.new("Sneha Iyer",1234,"9876543213")
    c5 = Customer.new("Arjun Reddy",1234,"9876543214")

    @list_of_customer += [c1, c2, c3, c4, c5]

    b1 = Bank.new("SBI", 1_000_000, 10, 12, 1234)
    b2 = Bank.new("ICICI", 800_000, 9, 11, 1234)

    @list_of_bank += [b1, b2]

    s1 = SavingsAccount.new(50_000, b1, c1, 1234)
    s2 = SavingsAccount.new(20_000, b1, c2, 1234)
    s3 = SavingsAccount.new(15_000, b2, c3, 1234)

    cur1 = CurrentAccount.new(10_000, b1, c1, 1234)
    cur2 = CurrentAccount.new(-7000, b1, c2, 1234)  # negative balance
    cur3 = CurrentAccount.new(-12000, b2, c4, 1234) # risky account

    l1 = LoanAccount.new(200_000, b1, c1, 1234 ,200_000 +  EMIEngine.calculate(200_000, 10, 5),  true)
    l2 = LoanAccount.new(50_000, b2, c3, 1234,50_000 +   InterestEngine.calculate(200_000, 10, 5),  true)
    l3 = LoanAccount.new(300_000, b1, c4, 1234,300_000 +   InterestEngine.calculate(200_000, 10, 5),  true)

    accounts = [s1, s2, s3, cur1, cur2, cur3, l1, l2, l3]

    accounts.each do |acc|
      acc.bank.list_of_account << acc
      acc.customer.list_of_account << acc
      @accounts_by_id[acc.id] = acc
    end

    t1 = Transaction.new(nil, s1.id, 50000, "DEPOSIT")
    t1.complete!("SUCCESS")

    t2 = Transaction.new(nil, s2.id, 20000, "DEPOSIT")
    t2.complete!("SUCCESS")

    t3 = Transaction.new(s1.id, cur1.id, 5000, "TRANSFER")
    t3.complete!("SUCCESS")

    t4 = Transaction.new(cur1.id, nil, 2000, "WITHDRAW")
    t4.complete!("SUCCESS")

    t5 = Transaction.new(nil, l1.id, 200000, "LOAN_DISBURSE")
    t5.complete!("SUCCESS")

    t6 = Transaction.new(c1.id, l1.id, 5000, "LOAN_REPAY")
    t6.complete!("SUCCESS")

    t7 = Transaction.new(nil, l2.id, 50000, "LOAN_DISBURSE")
    t7.complete!("SUCCESS")

    t8 = Transaction.new(s2.id, s3.id, 3000, "TRANSFER")
    t8.complete!("SUCCESS")

    t9 = Transaction.new(cur2.id, nil, 1000, "WITHDRAW")
    t9.complete!("SUCCESS")

    @list_of_transaction += [t1, t2, t3, t4, t5, t6, t7, t8, t9]
  end
end