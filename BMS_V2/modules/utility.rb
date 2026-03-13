module Utility
  def get_item_from_list(message, list)
    puts message
    id = gets.chomp.to_i

    item = list.find { |ele| ele.id == id }
    raise "Account not found" unless item

    verify_password("Enter password: ", item)

    item
  end

  def get_type_of_account(message)
    list = {1 => 'Loan',2 => 'Saving'}
    print message
    item = gets.chomp.to_i
    return item if list.member?(item)

    raise "Type not found. Allowed types: #{list.join(', ')}"

    rescue StandardError => e
      puts e.message
      retry
  end

  def verify_password(message, user)
    attempts = 0
  
    begin
      puts message
      password = gets.chomp.to_i
    
      raise "Incorrect Password" unless user.password == password
    rescue StandardError => e
      attempts += 1
      puts e.message
      retry if attempts < 3
      raise e
    end
  end
end