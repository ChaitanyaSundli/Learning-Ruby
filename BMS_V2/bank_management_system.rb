class BankManagementSystem
  attr_accessor :list_of_bank , :list_of_transaction , :list_of_customer 
  def initialize
    @list_of_customer = []
    @list_of_bank = []
    @list_of_transaction = []
  end

  def create_customer
  end

  def main()
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
      puts "9 : View Transactions"
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
      when 9
        view_transactions(users_list , bank_accounts , transactions)
      else puts "Something is wrong"
    end
end
  end

end

BankManagementSystem.new.main()