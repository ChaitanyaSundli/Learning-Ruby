module Validators
    def phone_validator(message)
    attempts ||= 0
    print message
    value = gets.chomp.strip
    digits_only = value.gsub(/\D/, '')
    
    raise StandardError, "Invalid phone number. Please enter a 10-digit number." unless digits_only.match?(/\A\d{10}\z/)
    raise "Phone No Already Registered" if @list_of_customer.any? {|customer_detail| customer_detail.phone == digits_only}

    value
    rescue StandardError => e
      attempts += 1
      puts "#{e.message} (Attempt #{attempts}/3)"

      if attempts < 3
        retry
      else
        puts "Maximum attempts reached."
        raise e
      end
  end

  def positive_input(message)
    attempts ||= 0
    print message
    value = Float(gets.chomp)
    raise StandardError, "Amount must be Greated than 0" if value <= 0

    value
    rescue StandardError => e
      attempts += 1
      puts e.message
      retry if attempts < 3
      raise e
  end

  def name_validator(message)
  attempts ||= 0
  print message
  value = gets.chomp.strip
  unless value.match?(/\A[a-zA-Z\s]{3,}\z/) || value == 'Om'
    raise StandardError, "Your name is not recognized as standard name Min 3 char and no number"
  end
  value
  rescue StandardError => e
    attempts += 1
    puts "#{e.message} (Attempt #{attempts}/3)"

    if attempts < 3
      retry
    else
      puts "Maximum attempts reached."
      raise e
    end
  end

  def bank_name_validator(message, list_of_bank)
    name = name_validator(message)
    raise "Name Already Taken" if list_of_bank.find{|ele| ele.name.casecmp(name)}
    rescue StandardError => e
      retry
  end

  def password_validator(message)
    loop do
      print "#{message}"
      password = gets.chomp.strip
      return password if password.match?(/\A\d{4}\z/)
      puts "Please Enter 4 Digit Pin"
    end
  end
end