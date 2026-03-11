class Customer
  #SHORT HAND FOR ATTRIBUTE ACCESSORS
  attr_accessor :accounts , :age
  attr_reader :id
  attr_writer :name

  def initialize(name, age)
    @name = name
    @age = age
    @accounts = {}
  end

  def check_accounts
    puts "Your accounts is #{@accounts}"
  end

  def withdraw_money(withdraw_amount)
    balance -= withdraw_amount
  end


  #Static Method
  # def self.id_generator
  #   id += 1
  # end


  #Static Variable
  @@id

  #attribute accessor GETTER
  def name
    @name
  end


  def speak
    puts "My name is #{@name}"
  end
  #SETTER
  # def age (age)
  #   @age = age
  # end


  private

  def pvt_method
    puts "this is a private method"
  end

end


customer1 = Customer.new("Chaitanya" ,23)
# customer2 = Customer.new("Sundli" , 24)
# customer1.check_accounts
# puts customer1.name
# customer1.age = 100
# puts customer1.to_s
# puts customer1.name
# customer1.age = 1000
# puts customer1.age


# class Duck
#   def speak
#     puts "Quack Quack !!"
#   end
# end
# class Person 
#   def speak
#     puts "Hello Good Morning"
#   end
# end

# def make_speak(obj)
#   obj.speak
# end



# make_speak(Person.new)
# make_speak(Duck.new)
# make_speak(customer1)

# puts customer1.respond_to?(:pvt_method)
# customer1.send(:pvt_method)

# module Greetings
#   def say_hello
#     puts "Hello from greeting"
#   end
#   def say_goodbye
#     puts "Goodbye"
#   end
# end

# class Using_Greetings
#   include Greetings
# end

# person = Using_Greetings.new
# person.say_goodbye
# person.say_hello

# module Animals
#   class Dog
#     def speak
#       puts "Woof"
#     end
#   end
#   class Cat 
#     def speak
#       puts "Meow"
#     end
#   end
# end

# module Robots
#   class Dog
#     def speak
#       puts "Beep Beep!!!"
#     end
#   end  
# end


# animal_dog = Animals::Dog.new
# animal_dog.speak

# module Greetings
#   def say_hello
#     puts "Hello from greeting"
#   end
#   def say_goodbye
#     puts "Goodbye"
#   end
# end

# class Using_Greetings_include
#   include Greetings
# end

# class Using_Greetings_extend
#   extend Greetings
# end

# class Using_Greetings_prepend
#   prepend Greetings
# end
# Using_Greetings_extend.say_hello
# Using_Greetings_include.new.say_hello

# module Loggable
#   def process_data
#     puts "Logging: Starting data processing"
#     super
#     puts "Logging: Finished data processing"
#   end
# end

# class DataProcessor
#   prepend Loggable

#   def process_data
#     puts "Processing the actual data"
#   end
# end

# class SimpleProcessor
#   include Loggable

#   def process_data
#     puts "Simple processing"
#     super rescue puts "No super method found"
#   end
# end

# puts "With prepend:"
# DataProcessor.new.process_data

# puts "\nWith include:"
# SimpleProcessor.new.process_data


class Vehicle
  def initialize 
    @engine = "V8"
  end
  def engine_on
    puts "Engine is on"
  end
end

class Car < Vehicle
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

Car.new("CHaitanya").engine_on