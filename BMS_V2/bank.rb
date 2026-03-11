class bank
  @@id
  attr_accessor :treasury , :list_of_account
  attr_reader :name , :id
  def initialize(name , treasury)
    @id = @@id
    @@id += 1
    @name = name
    @treasury = treasury
    @list_of_account = []
  end

  def withdraw
  end

  def deposit
  end

  def transfer
  end

  def get_loan
  end

  def repay_loan
  end

  def clear_loan
  end

  def emi
  end

  def create_account
  end
  
end