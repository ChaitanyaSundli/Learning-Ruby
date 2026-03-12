$users_list = {}    # format is like user id to user details
$bank_accounts = {} # format is like account id to acc details
$new_acc_id = {'val' => 0}
$acc_type_list = ['Saving' , 'Loan']
$new_user_id = {'val' => 0}
$new_transaction_id = {'val' => 0}
$transactions = {}
$EMI_RATE = 10.0

def register_user()
  $new_user_id['val'] += 1
  name = name_validator("Enter your name")
  password = password_validator("Set your password")
  $users_list[$new_user_id['val']] = {'name' => name ,'password' => password}
  puts "Your Id is #{$new_user_id['val']} very important"
end

def create_account()
  user_id = check_id_availability("Enter your User Id" , $users_list)
  raise "This account does not exists" unless user_id

  puts "Enter your user password"
  user_password = gets.chomp
  raise "Incorrect Password" unless verify_password($users_list , user_id , user_password)

  $new_acc_id['val'] += 1
  type = check_type_availability("Enter your Acc Type \nEnter 'Loan' or 'Saving'" , $acc_type_list)
  raise "Unknow Account Type" unless type

  password = password_validator("Set your password")
  $bank_accounts[$new_acc_id['val']] = type == 'Saving' ? {'type' => 'Saving' ,'user_id' => user_id, 'password' => password , 'balance' => 0} : {'type' => 'Loan' ,'user_id' => user_id, 'password' => password , 'loan_amt' => 0}
end

def check_id_availability(message ,list)
  print message
  item = gets.chomp.to_i
  return item if list.include?(item)
end

def check_type_availability(message ,list)
  print message
  item = gets.chomp
  return item if list.include?(item)
end

def verify_password(list, id, password)
  list[id]['password'] == password
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

def password_validator(message)
  loop do
    print "#{message}"
    input = gets.chomp.strip
    return input if input.match?(/\A\d{4}\z/)

    puts "Please Enter 4 Digit Pin"
  end
end

def view_loans()
  user_id = check_id_availability("Enter your User Id" , $users_list)
  raise"This account does not exists" unless user_id

  puts "Enter user password"
  user_password = gets.chomp
  raise "Incorrect Password" unless verify_password($users_list , user_id , user_password)

  puts "These are your Loan accounts"
  your_accs = $bank_accounts.select{|key , value| key == user_id && value['type'] == 'Loan'}
  puts your_accs.except('password')
end

def deposit_money
  user_id,acc_to_use = verification_user_then_account('Saving')
  raise"Account not found" unless acc_to_use

  deposit_amt = positive_input("Amount to Deposit")
  $new_transaction_id['val'] += 1
  $transactions[$new_transaction_id['val']] = {'acc_id' => user_id , 'amount' => deposit_amt , 'type' => 'deposit' , 'create_at' => Time.now}
  $bank_accounts[acc_to_use]['balance'] += deposit_amt
  [deposit_amt,acc_to_use]
end

def withdraw_money
  user_id,acc_to_use = verification_user_then_account('Saving')
  raise "Account not found" unless acc_to_use

  withdraw_amt = positive_input("Amount to Withdraw")
  raise "Insufficient Balance" if $bank_accounts[acc_to_use]['balance'] < withdraw_amt

  $bank_accounts[acc_to_use]['balance'] -= withdraw_amt
  $new_transaction_id['val'] += 1
  $transactions[$new_transaction_id['val']] = {'acc_id' => acc_to_use ,  'amount' => withdraw_amt , 'type' => 'withdraw' , 'create_at' => Time.now}
  [withdraw_amt,acc_to_use]
end

def transfer_btw_accs
  user_id, acc_to_use = verification_user_then_account('Saving')
  return unless acc_to_use

  transfer_amt = positive_input("Amount to Transfer")

  raise "Transfer Failed: Insufficient Balance" if $bank_accounts[acc_to_use]['balance'] < transfer_amt

  print "Enter the Destination Account ID: "
  dest_acc_id = gets.chomp.to_i

  raise "Cannot transfer to that account" unless $bank_accounts.key?(dest_acc_id) && $bank_accounts[dest_acc_id] == 'Saving'

  $bank_accounts[acc_to_use]['balance'] -= transfer_amt
  $bank_accounts[dest_acc_id]['balance'] += transfer_amt
  $new_transaction_id['val'] += 1
  $transactions[$new_transaction_id['val']] = {'from_acc_id' => acc_to_use, 'to_acc_id'=> dest_acc_id, 'amount'=> transfer_amt, 'type'=> "transfer",'create_at'   => Time.now}

  puts "Transfer Successful!"
  puts "New Balance: #{$bank_accounts[acc_to_use]['balance']}"
end

def get_loan
  user_id,acc_to_use = verification_user_then_account('Loan')
  loan_amt = positive_input("Amount of loan")
  $bank_accounts[acc_to_use]['loan_amt'] += loan_amt if $bank_accounts[acc_to_use]['type'] == 'Loan'
  $new_transaction_id['val'] += 1
  $transactions[$new_transaction_id['val']] = {'acc_id' => user_id , 'amount' => loan_amt , 'type' => 'loan' , 'create_at' => Time.now}
end

def verification_user_then_account(type)
  user_id = check_id_availability("Enter your User Id" , $users_list)
  raise "This account does not exists" unless user_id

  puts "Enter user password"
  user_password = gets.chomp
  raise "Incorrect Password" unless verify_password($users_list , user_id , user_password)

  puts "These are your #{type} accounts"
  your_accs = $bank_accounts.select{|key , value| value['user_id'] == user_id && value['type'] == type}.transform_values { |v| v.except('password')}
  raise "No #{type} account" if your_accs.empty?

  puts your_accs.except('password')
  acc_to_use = check_id_availability("Enter your Account No to Use" ,your_accs)
  raise "This account does not exists" unless acc_to_use

  puts "Enter user acc password"
  acc_password = gets.chomp
  raise "Incorrect Password" unless verify_password($bank_accounts , acc_to_use , acc_password)

  [user_id,acc_to_use]
end

def repay_loan
  user_id,acc_to_use = verification_user_then_account('Loan')
  raise "Account not found" unless acc_to_use

  repay_amt = positive_input("Repay Amount of loan")
  raise "Your paying too much" if $bank_accounts[acc_to_use]['loan_amt'] < repay_amt

  $bank_accounts[acc_to_use]['loan_amt'] -= repay_amt
  puts "Loan remaining #{$bank_accounts[acc_to_use]['loan_amt']}"
end

pr = ->( principal , years ) do 
  r = $EMI_RATE.to_f / (12 * 100.0)
  n = years.to_f * 12
  emi = (principal.to_f * r * (1 + r)**n) / ((1 + r)**n - 1)
  emi
end

while true do
  begin
  puts "1 : Register User"
  puts "11: View Registered Users"
  puts "2 : Create Account"
  puts "22: View Accounts"
  puts "3 : Deposit money into an account"
  puts "4 : Withdraw money from an account"
  puts "5 : Transfer money between two accounts"
  puts "6 : Get Loan"
  puts "66 : view Loans"
  puts "7 : EMI calculator (Using Lambda)"
  puts "8 : Repay Loan"
  puts "9 : View Transactions"
  puts "Enter Choice"
  x = gets.chomp.to_i
  case x
  when 1
    register_user
  when 11
    puts $users_list
  when 2
    create_account
  when 22
    puts $bank_accounts
  when 3
    deposit_money
  when 4
    withdraw_money
  when 5
    transfer_btw_accs
  when 6
    get_loan
  when 66
    view_loans
  when 7
    years = positive_input("Enter number of years")
    principal = positive_input("Enter principal amount")
    emi_amt = pr.call(principal , years)
    puts "Your Monthly EMI is #{emi_amt}"
  when 8
    repay_loan()
  when 9
    puts $transactions
  else puts "Something is wrong"
  end
  rescue StandardError => e
    puts "Error Message = #{e.message}"
  end
end
