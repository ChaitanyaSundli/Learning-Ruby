require_relative "../modules/validators"
require_relative "../modules/utility"

class Bank
  
  extend Validators
  extend Utility

  @@id = 0
  attr_accessor :treasury , :list_of_account
  attr_reader :name , :id , :EMI_RATE , :LOAN_RATE
  def initialize(name , treasury, emi_rate, loan_rate, password)
    @@id += 1
    @id = @@id
    @name = name
    @treasury = treasury
    @list_of_account = []
    @is_active = true
    @created_at = Time.now
    @updated_at = Time.now
    @deleted_at = nil
    @EMI_RATE = emi_rate
    @LOAN_RATE = loan_rate
    @password = password
  end

  def to_s
    "\n---------BANK DETAILS---------\nName : #{@name}\nEMI Rate : #{@EMI_RATE}\nLoan Rate : #{@LOAN_RATE}\n\n\n\n---------------------------"
  end

  def self.withdraw
    
  end

  def self.transfer(sender, reciever)
    transfer_amt = positive_input("Amount to Transfer")
    raise "Transfer Failed: Insufficient Balance" if sender.balance < transfer_amt

    print "Enter the Destination Account ID: "
    sender.balance -= transfer_amt
    reciever.balance += transfer_amt

  end

  def self.get_loan
  end

  def self.repay_loan
  end

  def self.clear_loan
  end

  def self.emi
  end

  def self.create_account(bank, customer)
    puts "Enter choice for Account Type"
    puts "1: Saving"
    puts "2: Loan"
    choice = gets.chomp.to_i

    if choice == 1
      balance = positive_input("Enter initial balance :")
      password = password_validator("Enter account password :")
      account = SavingsAccount.new(balance, bank, customer, password)
    else
      loan_amt = positive_input("Enter loan amount :")
      password = password_validator("Enter account password :")
      account = LoanAccount.new(loan_amt, bank, customer, password)
    end

    bank.list_of_account << account
    customer.list_of_account << account
    puts "Account created successfully"
    account
  end

  
end