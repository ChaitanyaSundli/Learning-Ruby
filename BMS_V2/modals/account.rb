require_relative "../modules/validators"
require_relative "../modules/utility"

class Account
  include Utility,Validators
  @@id = 1

  attr_accessor :password, :bank, :is_active
  attr_reader :customer

  def initialize(bank, customer, password)
    @bank = bank
    @customer = customer
    @is_active = true
    @created_at = Time.now
    @updated_at = Time.now
    @deleted_at = nil
    @password = password
  end
end

class LoanAccount < Account
  attr_accessor :loan_amt
  attr_reader :id
  def initialize(loan_amt, bank, customer, password)
    super(bank , customer, password)
    @id = @@id
    @@id += 1
    @loan_amt = loan_amt
  end
  def to_s
    "AccountID: #{@id} | Type: Loan | Loan Amount: #{@loan_amt} | Customer Name: #{@customer.name} | Bank: #{@bank.name}"
  end
end

class SavingsAccount < Account
  attr_accessor :balance
  attr_reader :id
  def initialize(balance, bank, customer, password)
    super(bank, customer, password)
    @id = @@id
    @@id += 1
    @balance = balance
  end

  def deposit
    amt = positive_input("Enter amount :")
    @balance += amt
    @bank.treasury += amt
    [amt,"Successful"]
  end

  def withdraw()
    amt = positive_input("Enter amount :")
    raise "Insufficient Balance" if amt > @balance
    raise "Bank is Broke" if amt > @bank.treasury
    @balance -= amt
    @bank.treasury -= amt
    
    [amt,"Successful"]
  end

  def to_s
    "AccountID: #{@id} | Type: Saving | Balance: #{@balance} | #{@customer} | Bank: #{@bank.name}"
  end
end

