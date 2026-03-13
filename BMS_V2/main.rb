require_relative 'bank_management_system'
require 'pry'
bms = BankManagementSystem.new
bms.seed_dummy_data
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
    puts "16  Create Bank"
    puts "\n0 Exit"
    print "\nEnter Choice: "
    input = gets.chomp
    raise "Invalid menu input" unless input.match?(/\A\d+\z/)

    x = input.to_i
    case x
    when 1
      bms.register_user
    when 2
      puts bms.list_of_customer
    when 3
      bms.create_account
    when 4
      bms.view_bank_accounts
    when 5
      bms.view_my_accounts
    when 6
      bms.deposit_money
    when 7
      bms.withdraw_money
    when 8
      bms.transfer_btw_accs
    when 9
      bms.repay_loan
    when 10
      bms.close_loan_account
    when 11
      bms.view_loans
    when 12
      years = positive_input("Years: ")
      principal = positive_input("Principal: ")
      puts "Monthly EMI = #{pr.call(principal,years)}"
    when 13
      puts $transactions
    when 14
      bms.view_repaid_loan
    when 15
      bms.view_repaid_loan_more_than_half
    when 16
      bms.create_bank
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