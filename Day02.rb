# Conditional Statements


# if else in Ruby
# age = 18

# if age < 18 
#   0puts "Minor" 
# elsif age > 18
#   puts "Major"
# else 
#   puts "Just the Right Age"
# end

# Cases in Ruby
# battery = 12
# case battery
# when 1..20
#   puts "Red Low Battery charging recommended"
# when 21..50
#   puts "Yellow Mid Battery"
# when 51..75
#   puts "Greenish Yellow"
# when 76..100 then puts "Green You are ready for the day"
# else
#   puts "Black Your device needs service"
# end 

# One line if
# time = 12
# puts "less than 10" if time < 10
# puts time < 10 ? "less than 10" :  "greater than 10"


#LOOPS

# for i in 1..10
#   puts "2 x #{i} = #{i*2}"
# end

# 5.times do 
#   puts "Hello , World"
# end

# 10.times do |i|
#   puts "2 x #{i+1} = #{(i+1)*2}"
# end

# i = 1
# loop do 
#   puts "Learning #{i}"
#   i += 1
#   break if i > 3
# end

# i = 1
# while i <= 3 do
#   puts "Learning #{i}"
#   i += 1
# end

# i = 1
# unless i > 4 
#   puts "Learning #{i}"
#   i += 1
# end

# 5.upto(10) do |n|
#   puts "hi #{n}"
# end

#Learing Yield of Ruby (Callback in js , Lambda in Java , Closure in Swift , Trailing Lambda in Kotlin)

# def logger(nums)
#   p "Hello"
#   yield(nums)
#   p "Bye"
# end

# logger {puts 'Chaitanya'}


# logger do 
#   p [1,2,3]
# end

# pp = Proc.new { |nums| puts nums*nums}
# logger(10 , &pp)

# def logger
#   yield
# end

# p = proc{puts "hi"}
# logger {p}.call

# def call_proc1
#   puts "Before proc"
#   my_proc = Proc.new {return 2}
#   my_proc.call  
#   puts "After proc"
# end
# call_proc1

# def call_proc2
#   puts "Before lambda"
#   my_lambda = -> {return 2}
#   my_lambda.call
#   puts "After lambda"
# end
# call_proc2

begin
zero = 6/0
rescue
  puts "not a problem any more"
end