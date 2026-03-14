module Utility

  def get_item_from_list(message, list)

    print message
    id = gets.chomp.to_i

    list.find { |e| e.id == id }

  end

end