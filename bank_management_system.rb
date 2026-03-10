acc = {'type' => "Loan" , 'balance' => 10000 , 'password' => "abcd"}
user = {'name' => "Chaitanya" , 'Salary' => 10000 , "Gender" => "M" , 'age' => 18}
users_list = {}    # format is like user id to user details
bank_accounts = {} # format is like account id to acc details
acc_to_user = {}
new_acc_id = {'val' => 0}
new_user_id = {'val' => 0}
new_transaction_id = {'val' => 0}
loan = {}
transactions = {}

def create_account(bank_accounts , acc_to_user , users_list , new_acc_id)
  puts "Enter your User Id"
  user_id = gets.chomp.to_i
  puts "Enter your user password"
  user_password = gets.chomp
  unless verify_password(users_list , user_id , user_password)
    puts "Incorrect Password"
    return
  end
  new_acc_id['val'] += 1
  acc_to_user[new_acc_id['val']] = user_id
  puts "Enter your Acc Type"
  type = gets.chomp
  puts "Set your password"
  password = gets.chomp
  bank_accounts[new_acc_id['val']] = {'type' => type , 'password' => password , 'balance' => 0}
end

def register_user(new_user_id , users_list)
  new_user_id['val'] += 1
  puts "Enter your name"
  name = gets.chomp
  puts "Enter your Salary"
  salary = gets.chomp.to_i
  puts "Enter your gender"
  gender = gets.chomp
  puts "Enter your age"
  age = gets.chomp.to_i
  puts "Set your password"
  password = gets.chomp
  users_list[new_user_id['val']] = {'name' => name , 'Salary' => salary , "gender" => gender , 'age' => age , 'password' => password}
  puts "Your Id is #{new_user_id['val']} very important"
end

def verify_password(list, id, password)
  list.any? { |key, value| key == id && value['password'] == password }
end

def view_registered_users(users_list)
  puts users_list
end
def view_accounts(bank_accounts)
  puts bank_accounts
end

def view_loans(loan)
  puts loan
end

def deposit_money(acc_to_user ,users_list ,bank_accounts)
  puts "Enter your User Id"
  user_id = gets.chomp.to_i
  puts "Enter user password"
  user_password = gets.chomp
  unless verify_password(users_list , user_id , user_password)
    puts "Incorrect Password"
    return
  end
  puts "These are your account"
  puts acc_to_user.select{|key , value| value == user_id}


  puts "Enter your Account No to Use"
  acc_to_use = gets.chomp.to_i
  puts "Enter user acc password"
  acc_password = gets.chomp
  unless verify_password(bank_accounts , acc_to_use , acc_password)
    puts "Incorrect Password"
    return
  end
    puts "Amount to Deposit"
    balance = gets.chomp.to_i
    bank_accounts.filter do |key , value|
      if key==acc_to_use
        value['balance'] += balance
      end
    end
end

def withdraw_money(acc_to_user ,users_list ,bank_accounts)
  puts "Enter your User Id"
  user_id = gets.chomp.to_i
  puts "Enter user password"
  user_password = gets.chomp
  unless verify_password(users_list , user_id , user_password)
    puts "Incorrect Password"
    return
  end
  puts "These are your account"
  puts acc_to_user.select{|key , value| value == user_id}


  puts "Enter your Account No to Use"
  acc_to_use = gets.chomp.to_i
  puts "Enter user acc password"
  acc_password = gets.chomp
  unless verify_password(bank_accounts , acc_to_use , acc_password)
    puts "Incorrect Password"
    return
  end
    puts "Amount to Withdraw"
    balance = gets.chomp.to_i
    bank_accounts.filter do |key , value|
      if key==acc_to_use
        value['balance'] -= balance
      end
    end
end

def transfer_btw_accs(acc_to_user ,users_list , bank_accounts , transactions , new_transaction_id)
  puts "Enter your User Id"
  user_id = gets.chomp.to_i
  puts "Enter user password"
  user_password = gets.chomp
  unless verify_password(users_list , user_id , user_password)
    puts "Incorrect Password"
    return
  end
  puts "These are your account"
  puts acc_to_user.select{|key , value| value == user_id}
  puts "Enter your Account No to Use"
  acc_to_use = gets.chomp.to_i
  puts "Enter user acc password"
  acc_password = gets.chomp
  unless verify_password(bank_accounts , acc_to_use , acc_password)
    puts "Incorrect Password"
    return
  end
    puts "Amount to Transfer"
    transfer_amt = gets.chomp.to_i
    bank_accounts.filter do |key , value|
      if key==acc_to_use
        value['balance'] -= transfer_amt
      end
    end
    puts "Where to transfer acc id"
    where_to_transfer_id = gets.chomp.to_i

    bank_accounts.filter do |key , value|
      if key == where_to_transfer_id
        value['balance'] += transfer_amt
      end
    end
    new_transaction_id['val'] += 1
    transactions[new_transaction_id['val']] = {from_acc_id => acc_to_use , to_acc_id => where_to_transfer_id , amount => transfer_amt}
end

def emi_calculator
  puts "Enter annual interest rate "
  rate = gets.chomp.to_f
  
  puts "Enter number of years"
  years = gets.chomp.to_i
  
  puts "Enter principal amount"
  principal = gets.chomp.to_f
  pr = -> do
    r = rate / (12 * 100) 
    n = years * 12        
    emi = (principal * r * (1 + r)**n) / ((1 + r)**n - 1)
  end

  puts "Your Monthly EMI is #{pr.call}"
end

def validate_negative(to_validate_i)
  if to_validate_i < 0
    raise "Negative Input"
  to_validate
end

def get_loan(acc_to_user ,users_list ,bank_accounts ,loan)
  puts "Enter your User Id"
  user_id = gets.chomp.to_i
  puts "Enter user password"
  user_password = gets.chomp
  unless verify_password(users_list , user_id , user_password)
    puts "Incorrect Password"
    return
  end
  puts "These are your account"
  puts acc_to_user.select{|key , value| value == user_id}


  puts "Enter your Account No to Use"
  acc_to_use = gets.chomp.to_i
  puts "Enter user acc password"
  acc_password = gets.chomp
  unless verify_password(bank_accounts , acc_to_use , acc_password)
    puts "Incorrect Password"
    return
  end
    puts "Amount of loan"
    loan_amt = gets.chomp.to_i
    bank_accounts.filter do |key , value|
      if key==acc_to_use && value['type'] == 'Loan'
        loan[acc_to_use] = loan_amt
      else
        puts "this acc is not loan type"
      end
    end
end

def repay_loan(acc_to_user ,users_list ,bank_accounts ,loan)
  puts "Enter your User Id"
  user_id = gets.chomp.to_i
  puts "Enter user password"
  user_password = gets.chomp
  unless verify_password(users_list , user_id , user_password)
    puts "Incorrect Password"
    return
  end
  puts "These are your account"
  puts acc_to_user.select{|key , value| value == user_id}


  puts "Enter your Account No to Use"
  acc_to_use = gets.chomp.to_i
  puts "Enter user acc password"
  acc_password = gets.chomp
  unless verify_password(bank_accounts , acc_to_use , acc_password)
    puts "Incorrect Password"
    return
  end
    puts "Repay Amount of loan"
    loan_amt = gets.chomp.to_i
    bank_accounts.filter do |key , value|
      if key==acc_to_use && value['type'] == 'Loan'
        loan[acc_to_use] = loan[acc_to_use] - loan_amt
      end
    end
end

while true do
  puts "1 : Register User"
  puts "11: View Registered Users"
  puts "2 : Create Account"
  puts "22: View Accounts"
  puts "3 : Deposit money into an account"
  puts "4 : Withdraw money from an account"
  puts "5 : Transfer money between two accounts"
  puts "6 : Loan Functionality"
  puts "66 : view Loans"
  puts "7 : EMI calculator (Using Lambda)"
  puts "Enter Choice"
  x = gets.chomp.to_i
  case x
  when 1
    register_user(new_user_id , users_list)
  when 11
    view_registered_users(users_list)
  when 2
    create_account(bank_accounts , acc_to_user ,users_list, new_acc_id)
  when 22
    view_accounts(bank_accounts)
  when 3
    deposit_money(acc_to_user ,users_list , bank_accounts)
  when 4
    withdraw_money(acc_to_user ,users_list , bank_accounts)
  when 5
    transfer_btw_accs(acc_to_user ,users_list , bank_accounts , transactions , new_transaction_id)
  when 6
    get_loan(acc_to_user ,users_list , bank_accounts , loan)
  when 66
    view_loans(loan)  
  when 7
    emi_calculator()
  when 8
    repay_loan(acc_to_user ,users_list , bank_accounts , loan)
  else puts "Something is wrong"
  end
end
