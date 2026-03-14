module InterestEngine

  INTEREST_INTERVAL = 1 * 60

  def self.apply_interest(banks, transactions)

  banks.each do |bank|

    bank.list_of_account
      .select { |acc| acc.is_a?(LoanAccount) && acc.is_active }
      .each do |loan|

        elapsed = Time.now - loan.last_interest_time
        next if elapsed < INTEREST_INTERVAL

        principal = loan.is_emi ? loan.loan_amt : loan.total_amt_to_pay
        rate = loan.is_emi ? bank.EMI_RATE : bank.LOAN_RATE
        interest = principal * rate / 100.0

        if loan.is_emi
          loan.loan_amt += interest
        else
          loan.total_amt_to_pay += interest
        end

        loan.last_interest_time = Time.now
        bank.treasury += interest

        t = Transaction.new(loan.id, nil, interest, "INTEREST")
        transactions << t
        t.complete!("SUCCESS")

      end
  end
end

  def self.calculate(principal, rate, years)
    months = years * 12
    r = rate / (12.0 * 100.0)
    numerator = principal * r * ((1 + r)**months)
    denominator = ((1 + r)**months) - 1
    (numerator / denominator).round(2)
  end

end