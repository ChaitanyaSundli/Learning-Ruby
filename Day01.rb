=begin a = { "name" => "Chaitanya"}

puts "Hello World"
puts a.object_id
puts "  #{a.nil?}" 

a = {"name" => "Chaitanya" , "age" => 100}
b = {"Address" => "Ghaziabad" , "count" => 0}

puts 
c = {"null" => nil}

puts c
puts c.compact

puts a.keys

puts a.merge(b)

d = "This is a String"
puts d.reverse()
puts d.include?("is")
puts d.length()
puts d.count "is"
puts d.capitalize!
puts d.bytesize
puts "hi".bytesize
puts "%".encoding
puts "A".sum
puts "A".eql? "A"
puts "A".eql? "AB"
puts "A" == "A"
puts a.String
=end

# ARRAY BIGINS HERE
# An array literal:
# arr1 = [1, 'one', :one, [2, 'two', :two]]
# print arr1
# puts 
# # Array Using METHOD
# print arr2 = Array(["a", "b"])
# puts

# Diif way
# print Array.new(4) {|i| i.to_s } + "\n"


