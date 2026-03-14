require_relative 'bank_management_system'
require "./modules/emi_engine"
require "./modules/interest_engine"

bms = BankManagementSystem.new
bms.seed_dummy_data

while true
  begin

    puts "\n========= BANK SYSTEM ========="
    puts "1 Login" unless bms.session.role
    puts "2 Logout" if bms.session.role

    case bms.session.role

    when :customer
      puts "\nCustomer Actions"
      puts "4 View My Accounts"
      puts "5 Create Account"
      puts "6 Deposit"
      puts "7 Withdraw"
      puts "8 Transfer"
      puts "9 Repay Loan"
      puts "12 View Transactions"

    when :admin
      puts "\nBank Admin Actions"
      puts "11 View Bank Accounts"
      puts "12 View Transactions"

    when :bank_management
      puts "\nBank Management Actions"
      puts "3 Register User"
      puts "10 Create Bank"
      puts "11 View Bank Accounts"
      puts "12 View Transactions"
      puts "13 Risky Loans"
      puts "14 Risky Customers"
      puts "15 Loan Tenure Reduction"
      puts "16 Bank Profit"

    end

    x = gets.chomp.to_i

    case x

    when 1
      bms.login

    when 2
      bms.logout

    when 3
      bms.require_bank_management
      bms.register_user

    when 4
      bms.require_customer
      bms.view_my_accounts

    when 5
      bms.require_customer
      bms.create_account

    when 6
      bms.require_customer
      bms.deposit_money

    when 7
      bms.require_customer
      bms.withdraw_money

    when 8
      bms.require_customer
      bms.transfer_btw_accs

    when 9
      bms.require_customer
      bms.repay_loan

    when 10
      bms.require_bank_management
      bms.create_bank

    when 11
      if bms.session.role == :admin
        bms.view_bank_accounts
      else
        bms.require_bank_management
        bms.view_bank_accounts
      end

    when 12
      bms.view_transactions

    when 13
      bms.require_bank_management
      bms.risky_loans

    when 14
      bms.require_bank_management
      bms.risky_customers

    when 15
      bms.require_bank_management
      bms.loan_tenure_reduction

    when 16
      bms.require_bank_management
      bms.bank_profit

    else
      puts "Invalid option"
    end

    InterestEngine.apply_interest(bms.list_of_bank, bms.list_of_transaction)

  rescue => e
    puts "ERROR: #{e.message}"
  end
end