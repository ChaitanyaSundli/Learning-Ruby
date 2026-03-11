class Account
  @@id = 1
  def initialize(bank , customer)
    @bank = bank
    @customer = customer
  end
end

class LoanAccount < Account
  attr_accessor :loan_amt , :password , :bank
  attr_reader :customer , :id
  def initialize(loan_amt , password , bank , customer)
    super(bank , customer)
    @id = @@id
    @@id += 1
    @loan_amt = loan_amt
    @password = password
  end
end

class SavingsAccount < Account
  attr_accessor :balance , :password , :bank
  attr_reader :customer , :id
  def initialize(balance , password , bank , customer)
    super(bank , customer)
    @id = @@id
    @@id += 1
    @balance = balance
    @password = password
  end
end

