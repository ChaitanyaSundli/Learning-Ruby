module EMIEngine
  def self.calculate(principal, rate, years)
    months = years * 12
    r = rate / (12.0 * 100)
    numerator = principal * r * ((1 + r)**months)
    denominator = ((1 + r)**months) - 1
    (numerator / denominator).round(2)
  end

  def self.emis_remaining(emi_amount, total_amt_to_pay)
    return 0 if emi_amount <= 0
    (total_amt_to_pay.to_f / emi_amount).ceil
  end
end