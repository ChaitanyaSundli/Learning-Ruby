class Bank
  
  extend Validators
  
  RESERVE_RATIO = 0.10

  @@id = 1
  
  attr_accessor :treasury, :list_of_account
  attr_reader :name, :id, :EMI_RATE, :LOAN_RATE

  def initialize(name, treasury, emi_rate, loan_rate, password)

    @id = @@id
    @@id += 1

    @name = name
    @treasury = treasury

    @EMI_RATE = emi_rate
    @LOAN_RATE = loan_rate

    @password = password

    @list_of_account = []
    
  end


  def min_reserve
    @treasury * RESERVE_RATIO
  end

  def available_funds
    @treasury - min_reserve
  end

  def self.create_account(bank, customer)

    puts "\nChoose Account Type"
    puts "1 Savings"
    puts "2 Current"
    puts "3 Loan"

    choice = gets.chomp.to_i

    case choice

    when 1
      balance = positive_input("Initial Balance: ")
      pass = password_validator("Account PIN: ")

      acc = SavingsAccount.new(balance, bank, customer, pass)

    when 2
      balance = positive_input("Initial Balance: ")
      pass = password_validator("Account PIN: ")

      acc = CurrentAccount.new(balance, bank, customer, pass)

    when 3
      loan_amt = positive_input("Loan amount: ")

      raise "Bank must maintain 10% reserve" if loan_amt > bank.available_funds

      years = positive_input("No of Year : ")
      print "For Loan scheme Personal loan press 0 for EMI press 1 : "
      is_emi = gets.chomp.to_i
      raise "Invalid Input" unless is_emi == 1 || is_emi == 0
      
      if(is_emi == 1)
        rate = bank.EMI_RATE
        emi = EMIEngine.calculate(loan_amt, rate, years)
        total_payment = (emi * years * 12).round(2)
        interest_paid = (total_payment - loan_amt).round(2)
        puts
        puts "------ Loan Details ------"
        puts "Bank: #{bank.name}"
        puts "Principal Amount: #{loan_amt}"
        puts "Interest Rate: #{rate}% per year"
        puts "Tenure: #{years} years"
        puts "Monthly EMI: #{emi}"
        puts "Total Payment: #{total_payment}"
        puts "Total Interest Paid: #{interest_paid}"
        puts "WARNING: You will pay #{interest_paid} in interest over the loan period."
        puts "--------------------------"
      else
        rate = bank.LOAN_RATE
        interest = InterestEngine.calculate(loan_amt, rate, years)
        total_payment = (interest * years * 12).round(2)
        interest_paid = (total_payment - loan_amt).round(2)
        puts
        puts "------ Loan Details ------"
        puts "Bank: #{bank.name}"
        puts "Principal Amount: #{loan_amt}"
        puts "Interest Rate: #{rate}% per year"
        puts "Tenure: #{years} years"
        puts "Monthly Loan: #{interest}"
        puts "Total Payment: #{total_payment}"
        puts "Total Interest Paid: #{interest_paid}"
        puts "WARNING: You will pay #{interest_paid} in interest over the loan period."
        puts "--------------------------"
      end
      print "Proceed with loan? (y/n): "
      confirm = gets.chomp.downcase
      raise "Loan cancelled by user" unless confirm == "y"
      bank.treasury -= loan_amt
      pass = password_validator("Set Account PIN: ")
      acc = LoanAccount.new(loan_amt, bank, customer, pass, is_emi==1, total_payment)
    else
      raise "Invalid account type"
    end

    bank.list_of_account << acc
    customer.list_of_account << acc
    acc
  end


  def self.transfer(sender, receiver, transactions)
    amt = positive_input("Transfer amount: ")

    raise "Insufficient balance" if sender.balance < amt

    sender.balance -= amt
    receiver.balance += amt
    t = Transaction.new(sender.id, receiver.id, amt, "TRANSFER")
    transactions << t
    t.complete!("SUCCESS")
    puts "Transfer successful"

  end

end