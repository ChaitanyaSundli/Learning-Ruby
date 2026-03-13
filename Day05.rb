class Person
  attr_accessor :name, :email, :role

  def initialize(name, email, role)
    @name = name
    @email = email
    @role = role
  end

  def walk
    puts "Walking"
  end

  def talk
    puts "Talking"
  end

  def to_s
    ""
  end
end

p1 = Person.new("Chaitanya", "chai@gmail.com", "admin")
p2 = Person.new("Sundli", "sundli@gmail.com", "user")
p3 = Person.new("Singh", "singh@gmail.com", "user")
arr = [:walk, :talk]
users = [p1,p2,p3]
for ele in arr do
  p1.send(ele)
end

def find_by_attribute(users, attribute, value)
  users.select do |user| user.send(attribute) == value
  end
end
puts find_by_attribute(users, :role, 'admin')