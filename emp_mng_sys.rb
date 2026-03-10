
#Initializing

role = ["Jr" , "Sr" , "Mng" , "ITO" , "NA"]

emp1 = { empid: 1 ,'name' => "Chaitanya" , 'role' => role[0] , :age => 22 , 'email' => "chaitanya@gmail.com"}
emp2 = { empid: 2 ,'name' => "Jatin" , 'role' => role[0] , :age => 23 , 'email' => "jatin@gmail.com"}
emp3 = { empid: 3 ,'name' => "Aman" , 'role' => role[1] , :age => 25 , 'email' => "aman@gmial.c"}
emp4 = { empid: 4 ,'name' => "Shailesh" , 'role' => role[3] , :age => 40 , 'email' => nil}
emp5 = { empid: 5 ,'name' => "Rishikesh" , 'role' => role[2] , :age => 30 , 'email' => "dvfba"}

input = {empid: 6 , 'name' => "new member" , 'role' => role[4] , :age => 100 , 'email' => "NA@gmail.com"}

# EMS => EMPLOYEE MANAGEMENT System
# Array EMS Not implemented Hash is the target today
arr_ems = [emp1,emp2,emp3,emp4,emp5]
hash_ems = {emp1:,emp2:,emp3:,emp4:,emp5:}
# puts hash_ems["emp#{5}".to_sym]
# Array Approach

#Displaying ARRAY EMS
# puts " \n Before Operation ARR EMS\n\n"
# puts arr_ems
# puts


#Displaying EMS
# ems => Hash ems or Array ems
def display_ems(ems) 
  puts ems
  puts
end

#Add Employee function
def add_employee_array(ems , data)
  puts("After Update ARR EMS\n\n")
  ems.push(data)
  print ems
  puts
end

#Add Employee function
def add_employee_hash(ems , empid,name ,role, age , email)
  puts("After Update HSH EMS\n\n")
  ems["emp#{empid}"] = { empid:, name:, role:, age:, email: }
  print ems
  puts
end

#Delete Employee function
def delete_by_name (ems , name)
  ems.each {|key , value| value["name"] == name ? ems.delete(key) : ""}
  puts ems
end

#Deleting hard using key name
def delete_by_key(ems , key)
  ems.delete(key)
  display_ems(ems)
end

#Update Functions

#update by key
def update_name_by_empid(ems , new_name , empid)
  ems.fetch(:"emp#{empid}")["name"] = new_name   #Not working for invalid key harded coded needs loop to learn
  display_ems(ems)
end

#Remove All
def remove_all_method_style(ems)
  ems.clear
  display_ems(ems)
end

def remove_all_value_style(ems)
  ems = {}
  display_ems(ems)
end

def is_empty?(ems)
  puts ems.empty?
end

def is_equal?(ems , value1 , value2)
  puts ems[value1] == ems[value2]
end

def display_as_string(ems)
  puts ems.to_s
end

def total_nums_emp(ems)
  puts ems.length
end

def append_employee_list(hash1 , hash2)
  hash1.merge!(hash2)
  puts hash1
end

def validate_empid?(ems , empid)
  print !ems.has_key?(:"emp#{empid}")
end

def get_emp_hash_as_array(ems)
  print ems.to_a
end

def validate_email(ems , email)
  regexp = Regexp.new("@gmail.com")
  puts email.match?(regexp) ? true : false
end




#Calling Operations

# display_ems(hash_ems)
# add_employee_array(arr_ems , input) #Adding in array
# add_employee_hash(hash_ems , 6 ,"new member" , role[4] , 100 ,"NA@gmail.com")
# delete_by_key(hash_ems , :emp1)
# delete_by_name(hash_ems , "Jatin")
# update_name_by_empid(hash_ems , "Sundli" , 4)
# remove_all_value_style(hash_ems)
# remove_all_method_style(hash_ems)
# is_empty?(hash_ems)
# is_equal?(hash_ems , emp1 , emp2)
# display_as_string(hash_ems)
# total_nums_emp(hash_ems)

# emp7 = { empid: 7 ,'name' => "New Man" , 'role' => role[0] , :age => 400 , 'email' => "uk@gmail.com"}   # Dummy Data
# emp8 = { empid: 8 ,'name' => "Uttarkashi" , 'role' => role[0] , :age => 300 , 'email' => "ukk@gmail.com"}
# dummy_append_data = {emp7: , emp8:}
# append_employee_list(hash_ems , dummy_append_data)
# validate_empid?(hash_ems , "0")
# get_emp_hash_as_array(hash_ems)
validate_email(hash_ems , "@gmail.om")
