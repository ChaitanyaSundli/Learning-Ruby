class Customer
  attr_accessor :name, :password, :list_of_account, :phone
  attr_reader :id
  @@id = 0
  def initialize (name , password , phone)
    @name = name
    @password = password
    @@id += 1
    @id = @@id
    @list_of_account = []
    @phone = phone
    @created_at = Time.now
    @updated_at = Time.now
    @deleted_at = nil
  end

  def to_s 
    "Name :  #{@name} | Phone : #{@phone} | User ID : #{@id}"
  end
end