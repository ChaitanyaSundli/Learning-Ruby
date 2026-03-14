class Transaction

  attr_reader :id, :from, :to, :amount, :type, :status, :time

  @@id = 1

  def initialize(from, to, amount, type)

    @id = @@id
    @@id += 1

    @from = from
    @to = to
    @amount = amount
    @type = type
    @status = "PENDING"
    @time = Time.now

  end

  def complete!(status)
    @status = status
  end

  def to_s
    "TXN #{@id} | #{@type} | #{amount} | #{status} | #{time.strftime("%d-%m-%Y %H:%M")}"
  end

end