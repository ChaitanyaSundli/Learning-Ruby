class Customer

  attr_accessor :name, :password, :list_of_account, :phone
  attr_reader :id
  @@id = 1

  def initialize(name, password, phone)
    @name = name
    @password = password
    @phone = phone
    @id = @@id
    @@id += 1
    @list_of_account = []
  end

  def to_s
    "ID #{@id} | #{@name} | #{@phone}"
  end

end