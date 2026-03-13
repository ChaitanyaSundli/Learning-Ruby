class Transaction
  attr_reader :from_account_id, :to_account_id, :created_at, :amount, :type, :status, :ended_at
  @@id = 1
  def initialize(from_account, to_account, status, type)
    @from_account = from_account
    @to_account = to_account
    @created_at = Time.now
    @ended_at = nil
    @amount = amount
    @status = status
    @id = @@id
    @@id += 1
    @type = nil
  end
  def completed(status)
    @ended_at = Time.now
    @status = status
  end
end