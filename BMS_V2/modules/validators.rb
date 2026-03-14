module Validators

  def positive_input(message)
    attempts = 0
    loop do
      print message
      value = gets.chomp

      begin
        num = Float(value)
        raise "Must be greater than 0" if num <= 0
        return num
      rescue
        attempts += 1
        puts "Invalid input"
        retry if attempts < 3
        raise "Too many invalid attempts"
      end
    end
  end

  def phone_validator(phone, customers)
    
    raise "Phone must be 10 digits" unless phone.match?(/\A\d{10}\z/)
    
    exists = customers.any? { |c| c.phone == phone }
    
    raise "Phone number already registered" if exists
    
    phone
    
  end

  def password_validator(message)
    loop do
      print message
      pass = gets.chomp
      return pass if pass.match?(/\A\d{4}\z/)
      puts "Enter 4 digit PIN"
    end
  end

  def name_validator(message)
    loop do
      print message
      name = gets.chomp.strip
      return name if name.match?(/\A[a-zA-Z ]{2,50}\z/)
      puts "Invalid name"
    end
  end

end