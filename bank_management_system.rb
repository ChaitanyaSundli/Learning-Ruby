$users_list = {}    # format is like user id to user details
$bank_accounts = {} # format is like account id to acc details
$new_acc_id = {'val' => 0}
$acc_type_list = ['Saving', 'Loan']
$new_user_id = {'val' => 0}
$new_transaction_id = {'val' => 0}
$transactions = {}
$EMI_RATE = 10.0

# Dummy Data
$users_list[1] = {
  'name' => 'Rahul Sharma',
  'phone' => '9876543210',
  'password' => '1234',
  'created_at' => Time.now
}
$users_list[2] = {
  'name' => 'Priya Verma',
  'phone' => '9123456789',
  'password' => '4321',
  'created_at' => Time.now
}
$new_user_id['val'] = 2
$bank_accounts[1] = {
  'type' => 'Saving',
  'user_id' => 1,
  'password' => '1111',
  'balance' => 5000,
  'is_active' => true,
  'created_at' => Time.now,
  'updated_at' => Time.now
}
$bank_accounts[2] = {
  'type' => 'Loan',
  'user_id' => 2,
  'password' => '2222',
  'loan_amt' => 20000,
  'interest' => 2000,
  'repaid' => 5000,
  'is_active' => true,
  'created_at' => Time.now,
  'updated_at' => Time.now
}
$new_acc_id['val'] = 2


def register_user()
  $new_user_id['val'] += 1
  puts "\n--- USER REGISTRATION ---"
  name = name_validator("Enter your name: ")
  phone = phone_validator("Enter phone number: ")
  password = password_validator("Set your 4 digit PIN: ")

  $users_list[$new_user_id['val']] = {
    'name' => name,
    'phone' => phone,
    'password' => password,
    'created_at' => Time.now
  }

  puts "User Registered Successfully"
  puts "Your User ID is #{$new_user_id['val']}"
end

def check_id_availability(message, list)
  print message
  item = gets.chomp.to_i
  raise "ID not found" unless list.key?(item)

  item
end

def create_account
  user_id = check_id_availability("Enter your registration number: ", $users_list)
  raise "User does not exist" unless user_id

  verify_password($users_list, user_id, "Enter password: ")
  puts "\n--- CREATE ACCOUNT ---"
  type = check_type_availability("Enter Account Type (Saving / Loan): ", $acc_type_list)
  $new_acc_id['val'] += 1
  password = password_validator("Set account PIN: ")

  if type == 'Saving'
    balance = positive_input("Enter Initial Balance: ")
    $bank_accounts[$new_acc_id['val']] = {
      'type' => 'Saving',
      'user_id' => user_id,
      'password' => password,
      'balance' => balance,
      'is_active' => true,
      'created_at' => Time.now,
      'updated_at' => Time.now
    }

  else
    existing_loan = $bank_accounts.values.any? do |acc|
    acc['user_id'] == user_id &&
    acc['type'] == 'Loan' &&
    acc['is_active']
  end

  raise "User already has active loan account" if existing_loan
  
  loan_amt = positive_input("Enter Loan Amount: ")
  interest = loan_amt * $EMI_RATE / 100
  $bank_accounts[$new_acc_id['val']] = {
    'type' => 'Loan',
    'user_id' => user_id,
    'password' => password,
    'loan_amt' => loan_amt,
    'interest' => interest,
    'repaid' => 0,
    'is_active' => true,
    'created_at' => Time.now,
    'updated_at' => Time.now
  }
  $new_transaction_id['val'] += 1
  $transactions[$new_transaction_id['val']] = {
    'acc_id' => $new_acc_id['val'],
    'amount' => loan_amt,
    'interest' => interest,
    'type' => 'loan',
    'created_at' => Time.now
  }
  end

  puts "Account Created Successfully"
  puts "Account ID: #{$new_acc_id['val']}"
end


def check_type_availability(message, list)
  print message
  item = gets.chomp.strip
  return item if list.include?(item)

  raise "Type not found. Allowed types: #{list.join(', ')}"

  rescue StandardError => e
    puts e.message
    retry
end

def verify_password(list, id, message)
  print message
  password = gets.chomp
  raise "Incorrect Password" unless list[id]['password'] == password
end

def phone_validator(message)
  print message
  phone = gets.chomp.strip
  raise "Phone must be 10 digits" unless phone.match?(/\A\d{10}\z/)

  exists = $users_list.values.any? { |u| u['phone'] == phone }
  raise "Phone already registered" if exists

  phone

rescue StandardError => e
  puts e.message
  retry
end

def view_my_accounts
  user_id = check_id_availability("Enter your User ID: ", $users_list)
  raise "User not found" unless user_id

  verify_password($users_list, user_id, "Enter password: ")
  puts "\n----- YOUR ACCOUNTS -----"
  your_accs = $bank_accounts.select { |k,v| v['user_id'] == user_id }
  raise "No accounts found" if your_accs.empty?

  your_accs.each do |acc_id , details|
    puts "\nAccount ID: #{acc_id}"
    puts "Type: #{details['type']}"
    puts "Active: #{details['is_active']}"

    if details['type'] == 'Saving'
      puts "Balance: #{details['balance']}"
    else
      total = details['loan_amt'] + details['interest']
      puts "Loan Amount: #{details['loan_amt']}"
      puts "Interest: #{details['interest']}"
      puts "Repaid: #{details['repaid']}"
      puts "Remaining: #{total - details['repaid']}"
    end

  end
end

def close_loan_account

  user_id,acc_to_use = verification_user_then_account('Loan')

  total = $bank_accounts[acc_to_use]['loan_amt'] + $bank_accounts[acc_to_use]['interest']
  repaid = $bank_accounts[acc_to_use]['repaid']
  raise "Loan not fully repaid" unless repaid >= total

  $bank_accounts[acc_to_use]['is_active'] = false
  $bank_accounts[acc_to_use]['closed_at'] = Time.now

  puts "Loan account closed successfully"
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

def view_loans
  user_id = check_id_availability("Enter your User Id", $users_list)
  raise"This account does not exists" unless user_id

  verify_password($users_list, user_id, "Enter password: ")
  puts "These are your Loan accounts"
  your_accs = $bank_accounts.select{|key, value| value['user_id'] == user_id && value['type'] == 'Loan'}
  your_accs.each do |id, acc|
  puts({
    'type' => acc['type'],
    'loan_amt' => acc['loan_amt'],
    'interest' => acc['interest'],
    'repaid' => acc['repaid']
  })
  end
end

def deposit_money
  user_id,acc_to_use = verification_user_then_account('Saving')
  raise "Account not active" unless $bank_accounts[acc_to_use]['is_active']

  deposit_amt = positive_input("Enter Amount to Deposit: ")
  $bank_accounts[acc_to_use]['balance'] += deposit_amt
  $bank_accounts[acc_to_use]['updated_at'] = Time.now
  $new_transaction_id['val'] += 1
  $transactions[$new_transaction_id['val']] = {
    'acc_id' => acc_to_use,
    'amount' => deposit_amt,
    'type' => 'deposit',
    'created_at' => Time.now
  }

  puts "Deposit Successful"
  puts "New Balance: #{$bank_accounts[acc_to_use]['balance']}"
end

def withdraw_money
  user_id,acc_to_use = verification_user_then_account('Saving')
  raise "Account not found" unless acc_to_use

  withdraw_amt = positive_input("Amount to Withdraw")
  raise "Insufficient Balance" if $bank_accounts[acc_to_use]['balance'] < withdraw_amt

  $bank_accounts[acc_to_use]['balance'] -= withdraw_amt
  $new_transaction_id['val'] += 1
  $transactions[$new_transaction_id['val']] = {'acc_id' => acc_to_use,  'amount' => withdraw_amt, 'type' => 'withdraw', 'created_at' => Time.now}
  [withdraw_amt,acc_to_use]
end

def transfer_btw_accs
  user_id, acc_to_use = verification_user_then_account('Saving')
  return unless acc_to_use

  transfer_amt = positive_input("Amount to Transfer")

  raise "Transfer Failed: Insufficient Balance" if $bank_accounts[acc_to_use]['balance'] < transfer_amt

  print "Enter the Destination Account ID: "
  dest_acc_id = gets.chomp.to_i
  raise "Cannot transfer to same account" if dest_acc_id == acc_to_use
  raise "Destination account not found" unless $bank_accounts.key?(dest_acc_id)
  raise "Destination account inactive" unless $bank_accounts[dest_acc_id]['is_active']
  raise "Destination must be Saving account" unless $bank_accounts[dest_acc_id]['type'] == 'Saving'

  $bank_accounts[acc_to_use]['balance'] -= transfer_amt
  $bank_accounts[dest_acc_id]['balance'] += transfer_amt
  $new_transaction_id['val'] += 1
  $transactions[$new_transaction_id['val']] = {'from_acc_id' => acc_to_use, 'to_acc_id'=> dest_acc_id, 'amount'=> transfer_amt, 'type'=> "transfer",'created_at'   => Time.now}

  puts "Transfer Successful!"
  puts "New Balance: #{$bank_accounts[acc_to_use]['balance']}"
end

def verification_user_then_account(type)
  user_id = check_id_availability("Enter your User Id", $users_list)
  raise "This account does not exists" unless user_id

  verify_password($users_list, user_id, "Enter password: ")
  puts "These are your #{type} accounts"
  your_accs = $bank_accounts.select{|key, value| value['user_id'] == user_id && value['type'] == type}.transform_values { |v| v.except('password')}
  raise "No #{type} account" if your_accs.empty?
  
  puts your_accs.except('password')
  acc_to_use = check_id_availability("Enter your Account No to Use", your_accs)
  raise "This account does not exists" unless acc_to_use
  raise "Account is inactive" unless $bank_accounts[acc_to_use]['is_active']

  verify_password($bank_accounts, acc_to_use, "Enter account password: ")

  [user_id,acc_to_use]
end

def view_repaid_loan 
  puts $transactions.filter {|key , value| value['type'] == 'loan_repay'}
end

def view_repaid_loan_more_than_half
  results = $transactions.select do |key, value|
    next false unless value['type'] == 'loan_repay'
    loan_amt = value['loan_amt'].to_f
    interest = value['interest'].to_f
    repaid   = value['repaid'].to_f
    (loan_amt + interest) / 2 < repaid
  end

  puts results
end

def repay_loan
  user_id,acc_to_use = verification_user_then_account('Loan')
  raise "Loan account is inactive" unless $bank_accounts[acc_to_use]['is_active']

  repay_amt = positive_input("Enter Repayment Amount: ")
  total_due = $bank_accounts[acc_to_use]['loan_amt'] + $bank_accounts[acc_to_use]['interest']
  new_total = $bank_accounts[acc_to_use]['repaid'] + repay_amt
  raise "Repay amount exceeds loan due" if new_total > total_due

  $bank_accounts[acc_to_use]['repaid'] += repay_amt
  $bank_accounts[acc_to_use]['updated_at'] = Time.now
  remaining = total_due - $bank_accounts[acc_to_use]['repaid']
  $new_transaction_id['val'] += 1
  $transactions[$new_transaction_id['val']] = {
    'acc_id' => acc_to_use,
    'loan_amt' => $bank_accounts[acc_to_use]['loan_amt'],
    'interest' => $bank_accounts[acc_to_use]['interest'],
    'repaid' => $bank_accounts[acc_to_use]['repaid'],
    'amount' => repay_amt,
    'type' => 'loan_repay',
    'created_at' => Time.now
  }

  puts "Repayment Successful"
  puts "Remaining Loan: #{remaining}"
end

pr = ->( principal, years ) do 
  r = $EMI_RATE.to_f / (12 * 100.0)
  n = years.to_f * 12
  emi = (principal.to_f * r * (1 + r)**n) / ((1 + r)**n - 1)
  emi
end

while true do
  begin
    puts "\n================================"
    puts "         BANK SYSTEM"
    puts "================================"
    puts "\nUSER"
    puts "1   Register User"
    puts "2   View Users"
    puts "\nACCOUNTS"
    puts "3   Create Account"
    puts "4   View All Accounts"
    puts "5   View My Accounts"
    puts "\nTRANSACTIONS"
    puts "6   Deposit"
    puts "7   Withdraw"
    puts "8   Transfer"
    puts "\nLOANS"
    puts "9   Repay Loan"
    puts "10  Close Loan (Soft Delete)"
    puts "11  View Loan Accounts"
    puts "\nUTILITIES"
    puts "12  EMI Calculator"
    puts "13  View Transactions"
    puts "14  Customers who repaid loan partially or fully"
    puts "15  Customers who repaid more than half loan"
    puts "\n0 Exit"
    print "\nEnter Choice: "
    input = gets.chomp
    raise "Invalid menu input" unless input.match?(/\A\d+\z/)

    x = input.to_i
    case x
    when 1
      register_user
    when 2
      puts $users_list
    when 3
      create_account
    when 4
      puts $bank_accounts
    when 5
      view_my_accounts
    when 6
      deposit_money
    when 7
      withdraw_money
    when 8
      transfer_btw_accs
    when 9
      repay_loan
    when 10
      close_loan_account
    when 11
      view_loans
    when 12
      years = positive_input("Years: ")
      principal = positive_input("Principal: ")
      puts "Monthly EMI = #{pr.call(principal,years)}"
    when 13
      puts $transactions
    when 14
      view_repaid_loan
    when 15
      view_repaid_loan_more_than_half
    when 0
      puts "\nThank you for using the Bank System"
      break

    else
      puts "Invalid choice. Please select from menu."
    end
  rescue StandardError => e
    puts "\nERROR: #{e.message}"
  ensure
    puts "\nPress ENTER to continue..."
    gets
  end
end