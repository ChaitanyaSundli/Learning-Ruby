users_list = {}    # format is like user id to user details
bank_accounts = {} # format is like account id to acc details
new_acc_id = {'val' => 0}
acc_type_list = ['Saving' , 'Loan']
new_user_id = {'val' => 0}
new_transaction_id = {'val' => 0}
loan = {} # format is line acc no to loan amount
transactions = {}
EMI_RATE = 10.0

def create_account(bank_accounts , users_list , new_acc_id , acc_type_list)
  user_id = check_id_availability("Enter your User Id" , users_list)
  (puts "This account does not exists"; return) unless user_id
  puts "Enter your user password"
  user_password = gets.chomp
  (puts "Incorrect Password" ;return) unless verify_password(users_list , user_id , user_password)
  new_acc_id['val'] += 1
  type = check_type_availability("Enter your Acc Type \nEnter 'Loan' or 'Saving'" , acc_type_list)
  (puts "Unknow Account Type" ; return) unless type
  password = password_validator("Set your password")
  bank_accounts[new_acc_id['val']] = type == 'Saving' ? {'type' => 'Saving' ,'user_id' => user_id, 'password' => password , 'balance' => 0} : {'type' => 'Loan' ,'user_id' => user_id, 'password' => password , 'loan_amt' => 0}
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

def register_user(new_user_id , users_list)
  new_user_id['val'] += 1
  name = name_validator("Enter your name")
  password = password_validator("Set your password")
  users_list[new_user_id['val']] = {'name' => name ,'password' => password}
  puts "Your Id is #{new_user_id['val']} very important"
end

def verify_password(list, id, password)
  list.any? { |key, value| key == id && value['password'] == password }
end

def positive_input(message)
  loop do
    print message
    begin
      value = Float(gets.chomp)
      return value unless value <= 0 
      puts "Amount must be positive"
    end
  end
end

def name_validator(message)
  loop do
    print "#{message}"
    value = gets.chomp.strip
    return value if value.match?(/\A[a-zA-Z\s]{3,}\z/) || value == 'Om'
    puts "Your name is not recognized as standard name Min 3 char and no number"
  end
end

def negative_checker(value)
  value.to_f < 0 ? value : nil
end

def password_validator(message)
  loop do
    print "#{message}"
    input = gets.chomp.strip
    return input if input.match?(/\A\d{4}\z/)
    puts "Please Enter 4 Digit Pin"
  end
end


def view_loans(users_list , bank_accounts)
  user_id = check_id_availability("Enter your User Id" , users_list)
  (puts "This account does not exists"; return) unless user_id
  puts "Enter user password"
  user_password = gets.chomp
  (puts "Incorrect Password" ;return) unless verify_password(users_list , user_id , user_password)
  puts "These are your Loan accounts"
  your_accs = bank_accounts.select{|key , value| key == user_id && value['type'] == 'Loan'}
  puts your_accs.except('password')
end

def view_registered_users(users_list)
  puts users_list
end
def view_accounts(bank_accounts)
  puts bank_accounts
end

def deposit_money(users_list ,bank_accounts , transactions , new_transaction_id)
  user_id,acc_to_use = verification_user_then_account(users_list , bank_accounts , 'Saving')
  return puts "Account not found" unless acc_to_use
  deposit_amt = positive_input("Amount to Deposit")
  new_transaction_id['val'] += 1
  transactions[new_transaction_id['val']] = {'acc_id' => user_id , 'amount' => deposit_amt , 'type' => 'deposit' , 'create_at' => Time.now}
  bank_accounts.filter do |key , value|
    if key == acc_to_use
      value['balance'] += deposit_amt
      return deposit_amt,acc_to_use
    end
  end
end

def withdraw_money(users_list ,bank_accounts ,transactions , new_transaction_id)
  user_id,acc_to_use = verification_user_then_account(users_list ,  bank_accounts , 'Saving')
  return puts "Account not found" unless acc_to_use
  withdraw_amt = positive_input("Amount to Withdraw") if withdraw_amt.to_i.zero?
  if bank_accounts[acc_to_use]['balance'] < withdraw_amt
    puts "Insufficient Balance"
    return
  end
  bank_accounts[acc_to_use]['balance'] -= transfer_amt
  new_transaction_id['val'] += 1
  transactions[new_transaction_id['val']] = {'acc_id' => acc_to_use ,  'amount' => withdraw_amt , 'type' => 'withdraw' , 'create_at' => Time.now} if withdraw_amt == 0
  return withdraw_amt,acc_to_use
end

def transfer_btw_accs( users_list, bank_accounts, transactions, new_transaction_id)
  user_id, acc_to_use = verification_user_then_account(users_list, bank_accounts , 'Saving')
  return unless acc_to_use
  transfer_amt = positive_input("Amount to Transfer")
  if bank_accounts[acc_to_use]['balance'] < transfer_amt
    puts "Transfer Failed: Insufficient Balance"
    return
  end
  print "Enter the Destination Account ID: "
  dest_acc_id = gets.chomp.to_i
  unless bank_accounts.key?(dest_acc_id) && bank_accounts[dest_acc_id] == 'Saving'
    puts "Cannot transfer to that account"
    return
  end
  bank_accounts[acc_to_use]['balance'] -= transfer_amt
  bank_accounts[dest_acc_id]['balance'] += transfer_amt
  new_transaction_id['val'] += 1
  transactions[new_transaction_id['val']] = {'from_acc_id' => acc_to_use, 'to_acc_id'=> dest_acc_id, 'amount'=> transfer_amt, 'type'=> "transfer",'create_at'   => Time.now}

  puts "Transfer Successful!"
  puts "New Balance: #{bank_accounts[acc_to_use]['balance']}"
end

def get_loan(users_list ,bank_accounts)
  user_id,acc_to_use = verification_user_then_account(users_list , bank_accounts , 'Loan')
  return puts "Account not found" unless acc_to_use
  loan_amt = positive_input("Amount of loan")
  bank_accounts.filter do |key , value|
    if key == acc_to_use && value['type'] == 'Loan'
      value['loan_amt'] += loan_amt
    else
      puts "this acc is not loan type"
    end
  end
end

def verification_user_then_account(users_list , bank_accounts , type)
  user_id = check_id_availability("Enter your User Id" , users_list)
  (puts "This account does not exists"; return) unless user_id
  puts "Enter user password"
  user_password = gets.chomp
  (puts "Incorrect Password" ;return) unless verify_password(users_list , user_id , user_password)
  puts "These are your #{type} accounts"
  your_accs = bank_accounts.select{|key , value| key == user_id && value['type'] == type}.transform_values { |v| v.except('password')}
  (puts "No #{type} account" ; return ) if your_accs.empty?
  puts your_accs.except('password')
  acc_to_use = check_id_availability("Enter your Account No to Use" ,your_accs)
  (puts "This account does not exists"; return) unless acc_to_use
  puts "Enter user acc password"
  acc_password = gets.chomp
  (puts "Incorrect Password" ;return) unless verify_password(bank_accounts , acc_to_use , acc_password)
  return user_id,acc_to_use
end

def repay_loan(users_list ,bank_accounts)
  user_id,acc_to_use = verification_user_then_account(users_list , bank_accounts , 'Loan')
  return puts "Account not found" unless acc_to_use
  repay_amt = positive_input("Repay Amount of loan")
  (puts "Your paying too much" ; return) if bank_accounts[acc_to_use]['loan_amt'] < repay_amt
  bank_accounts[acc_to_use]['loan_amt'] -= repay_amt
  puts "Loan remaining #{bank_accounts[acc_to_use]['loan_amt']}"
end

pr = ->( emi_rate , principal , years ) do 
  r = emi_rate.to_f / (12 * 100.0)
  n = years.to_f * 12
  emi = (principal.to_f * r * (1 + r)**n) / ((1 + r)**n - 1)
  emi
end

while true do
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
  puts "Enter Choice"
  x = gets.chomp.to_i
  case x
  when 1
    register_user(new_user_id , users_list)
  when 11
    view_registered_users(users_list)
  when 2
    create_account(bank_accounts , users_list , new_acc_id , acc_type_list)
  when 22
    view_accounts(bank_accounts)
  when 3
    deposit_money(users_list , bank_accounts , transactions , new_transaction_id)
  when 4
    withdraw_money(users_list , bank_accounts , transactions , new_transaction_id)
  when 5
    transfer_btw_accs(users_list , bank_accounts , transactions , new_transaction_id)
  when 6
    get_loan(users_list , bank_accounts)
  when 66
    view_loans(users_list , bank_accounts)  
  when 7
    years = positive_input("Enter number of years")
    principal = positive_input("Enter principal amount")
    emi_amt = pr.call(EMI_RATE , principal , years)
    puts "Your Monthly EMI is #{emi_amt}"
  when 8
    repay_loan(users_list , bank_accounts)
  else puts "Something is wrong"
  end
end
