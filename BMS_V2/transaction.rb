class Transaction
  attr_reader :from_account_id , :to_account_id , :created_at , :amount
  @@id = 1
  def initialize(from_account_id , to_account_id , amount)
    @from_account_id = from_account_id
    @to_account_id = to_account_id
    @created_at = Time.now
    @amount = amount
    @id = @@id
    @@id += 1
  end
end