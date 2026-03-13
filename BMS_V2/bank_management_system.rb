require_relative 'modals/account'
require_relative 'modals/bank'
require_relative 'modals/customer'
require_relative 'modals/transaction'
require "./modules/validators"
require "./modules/utility"

class BankManagementSystem

  include Validators,Utility
  
  attr_accessor :list_of_bank, :list_of_transaction, :list_of_customer 

  def initialize
    @list_of_customer = []
    @list_of_bank = []
    @list_of_transaction = []
    @list_of_account = []
    @created_at = Time.now
  end

  def create_bank
    puts "\n--- CREATE BANK ---\n"
    name = bank_name_validator("Enter Name :", @list_of_bank)
    treasury = positive_input("Enter your reserves :")
    emi_rate = positive_input("Enter EMI Rate : ")
    loan_rate = positive_input("Enter LOAN Rate : ")
    password = password_validator("Set BANK SECURITY PIN: ")
    @list_of_bank.push(Bank.new(name, treasury, emi_rate, loan_rate, password))
  end

  def view_bank_accounts
    @list_of_bank.each_with_index do |bank, i|
      puts "\n#{i + 1}. #{bank.name}"
      bank.list_of_account.each_with_index do |account, j|
        puts "   #{j + 1}. #{account}"
      end
    end
  end

  def create_account
    customer = get_item_from_list("Enter your customer ID number: ", @list_of_customer)
    raise "User does not exist" unless customer

    puts "\n--- CREATE ACCOUNT ---"
    puts "-----Choose Bank-----"

    @list_of_bank.each_with_index do |bank, index|
      puts "#{index + 1}. #{bank.name}"
    end

    bank = @list_of_bank[gets.chomp.to_i - 1]
    raise "Invalid bank" unless bank

    @list_of_account << Bank.create_account(bank, customer)
  end

  def register_user
    name = name_validator("Enter your name")
    password = password_validator("Set your password")
    phone = phone_validator("Enter Your Phone Number")
    @list_of_customer.push(Customer.new(name, password, phone))
    puts "\n\nYour Id Details\n #{@list_of_customer.last()}"
  end

  def view_my_accounts
    customer = get_item_from_list("Enter your customer ID number: ", @list_of_customer)
    raise "Customer not found" unless customer

    puts "\n--- YOUR ACCOUNTS ---"
    customer.list_of_account.each do |acc|
      puts acc
    end
  end

  def deposit_money
    customer = get_item_from_list("Enter your customer ID number: ", @list_of_customer)
    eligible_accounts = customer.list_of_account.select do |acc|
      acc.is_active && acc.instance_of?(SavingsAccount)
    end

    puts "Available Accounts"
    eligible_accounts.each_with_index do |acc, index|
      puts "#{index + 1}. #{acc}"
    end

    chosen_acc = eligible_accounts[gets.chomp.to_i - 1]
    chosen_acc.deposit
  end

def transfer_btw_accs
  customer = get_item_from_list("Enter your customer ID number: ", @list_of_customer)
  eligible_accounts = customer.list_of_account.select { |acc| acc.is_active && acc.is_a?(SavingsAccount) }
  puts "Select your Source Account:"
  eligible_accounts.each_with_index { |acc, i| puts "#{i + 1}. #{acc}" }
  sender_acc = eligible_accounts[gets.chomp.to_i - 1]
  raise "Invalid Account" unless sender_acc

  puts "Enter Recievers Acc No"
  id = gets.chomp.to_i
  receiver_acc = @list_of_account.find {|ele| ele.id == id}
  raise "Account not found" unless receiver_acc

  Bank.transfer(sender_acc, receiver_acc)
end


  def withdraw_money
    customer = get_item_from_list("Enter your customer ID number: ", @list_of_customer)
    eligible_accounts = customer.list_of_account.select do |acc|
      acc.is_active && acc.instance_of?(SavingsAccount)
    end

    puts "Available Accounts"
    eligible_accounts.each_with_index do |acc, index|
      puts "#{index + 1}. #{acc}"
    end

    chosen_acc = eligible_accounts[gets.chomp.to_i - 1]
    chosen_acc.withdraw
  end

  def seed_dummy_data
    c1 = Customer.new("Chaitanya", 1234, "9876543210")
    c2 = Customer.new("Sundli", 1234, "9123456789")
    @list_of_customer.concat([c1, c2])
    b1 = Bank.new("SBI", 1000000, 10, 12, 1234)
    b2 = Bank.new("UNION", 500000, 8, 15, 1234)
    @list_of_bank.concat([b1, b2])
    s1 = SavingsAccount.new(5000, b1, c1, 1234)
    s2 = SavingsAccount.new(1200, b2, c2, 1234)
    [s1, s2].each do |acc|
      acc.bank.list_of_account << acc
      @list_of_account << acc
      acc.customer.list_of_account << acc
    end
    l1 = LoanAccount.new(20000, b1, c1, 1234)
    l1.bank.list_of_account << l1
    l1.customer.list_of_account << l1
    puts "----Dummy Data Loaded Successfully----"
    puts "Customers: #{@list_of_customer.count}, Banks: #{@list_of_bank.count}"
  end
end