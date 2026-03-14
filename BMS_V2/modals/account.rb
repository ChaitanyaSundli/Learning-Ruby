require_relative "../modules/validators"
require_relative "../modules/utility"

class Account

  include Validators
  include Utility

  @@id = 1

  attr_accessor :bank, :password, :is_active
  attr_reader :customer, :id

  def initialize(bank, customer, password)

    @id = @@id
    @@id += 1

    @bank = bank
    @customer = customer
    @password = password

    @is_active = true

  end

end


class SavingsAccount < Account

  attr_accessor :balance

  def initialize(balance, bank, customer, password)
    super(bank, customer, password)
    @balance = balance
  end

  def deposit(system, amt)

    @balance += amt
    @bank.treasury += amt

    system.record_transaction(nil, @id, amt, "DEPOSIT")

    puts "Deposit successful"

  end

  def withdraw(system, amt)
    raise "Insufficient balance" if amt > @balance
    raise "Bank reserve requirement violation" if amt > @bank.available_funds

    @balance -= amt
    @bank.treasury -= amt
    system.record_transaction(@id, nil, amt, "WITHDRAW")
    puts "Withdrawal successful"
  end
end


class LoanAccount < Account
  attr_accessor :loan_amt, :last_interest_time, :total_amt_to_pay, :emi, :is_active
  attr_reader :is_emi

  def initialize(loan_amt, bank, customer, password, total_amt_to_pay, years, is_emi = false)
    super(bank, customer, password)
    @loan_amt = loan_amt
    @last_interest_time = Time.now
    @is_emi = is_emi
    @total_amt_to_pay = total_amt_to_pay
    @is_active = true
    @emi = EMIEngine.calculate(loan_amt, bank.EMI_RATE, years) if is_emi
  end
end

class CurrentAccount < Account

  attr_accessor :balance

  OVERDRAFT_LIMIT = 10000

  def initialize(balance, bank, customer, password)
    super(bank, customer, password)
    @balance = balance
  end

  def deposit(system, amt)
    @balance += amt
    @bank.treasury += amt
    system.record_transaction(nil, @id, amt, "DEPOSIT")
    puts "Deposit successful"
  end

  def withdraw(system, amt)
    if amt > (@balance + OVERDRAFT_LIMIT)
      raise "Overdraft limit exceeded"
    end
    raise "Bank treasury insufficient" if amt > @bank.treasury
    @balance -= amt
    @bank.treasury -= amt
    system.record_transaction(@id, nil, amt, "WITHDRAW")
    puts "Withdrawal successful"
  end

  def to_s
    "ID #{@id} | Current | Balance #{@balance} | OD #{OVERDRAFT_LIMIT}"
  end

end