module TransactionEngine

  def record_transaction(from, to, amount, type, list)

    t = Transaction.new(from, to, amount, type)

    list << t

    t.complete!("SUCCESS")

  end

end