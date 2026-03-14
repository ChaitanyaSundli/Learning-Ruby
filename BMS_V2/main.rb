require_relative 'bank_management_system'
require "./modules/emi_engine"
require "./modules/interest_engine"

bms = BankManagementSystem.new
bms.seed_dummy_data

while true
  begin
  puts "\n========= BANK SYSTEM ========="
  puts "1 Login"
  puts "2 Logout"
  puts "3 Register User"

  if bms.session.role == :customer

    puts "\nCustomer Actions"
    puts "4 View My Accounts"
    puts "5 Create Account"
    puts "6 Deposit"
    puts "7 Withdraw"
    puts "8 Transfer"
    puts "9 Repay Loan"
    puts "12 View Transactions"

  elsif bms.session.role == :admin

    puts "\nAdmin Actions"
    puts "10 Create Bank"
    puts "11 View Bank Accounts"
    puts "12 View Transactions"
    puts"13 Risky Loans"
    puts"14 Risky Customers"
    puts"15 Loan Tenure Reduction"
    puts "16 Bank Profit"
  end

  x = gets.chomp.to_i
  raise "Invalid Input" unless x
  case x
  when 1
    bms.login

  when 2
    bms.logout

  when 3
    bms.register_user

  when 4
    raise "Customer login required" unless bms.session.role == :customer
    bms.view_my_accounts

  when 5
    raise "Customer login required" unless bms.session.role == :customer
    bms.create_account

  when 6
    raise "Customer login required" unless bms.session.role == :customer
    bms.deposit_money

  when 7
    raise "Customer login required" unless bms.session.role == :customer
    bms.withdraw_money

  when 8
    raise "Customer login required" unless bms.session.role == :customer
    bms.transfer_btw_accs

  when 9
    raise "Customer login required" unless bms.session.role == :customer
    bms.repay_loan

  when 10
    raise "Admin login required" unless bms.session.role == :admin
    bms.create_bank

  when 11
    raise "Admin login required" unless bms.session.role == :admin
    bms.view_bank_accounts

  when 12
    bms.view_transactions

  when 13 then bms.risky_loans
  when 14 then bms.risky_customers
  when 15 then bms.loan_tenure_reduction
  when 16 then bms.bank_profit
  else
    puts "Invalid option. Please try again."
  end
  InterestEngine.apply_interest(bms.list_of_bank, bms.list_of_transaction)
  rescue => e
    puts "ERROR: #{e.message}"
  end
end
