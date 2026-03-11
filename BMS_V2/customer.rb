class Customer
  attr_accessor :name , :password , :list_of_account
  @@id = 1
  def initialize (name , password , phone)
    @name = name
    @password = password
    @@id += 1
    @list_of_account = []
    @phone = phone
  end
end