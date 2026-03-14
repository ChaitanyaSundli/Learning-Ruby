$arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
$player = true
$new_game = false

def reset_game
  $arr = [1,2,3,4,5,6,7,8,9]
  $player = true
end

def display
  puts "\n #{display_symbol(6)} | #{display_symbol(7)} | #{display_symbol(8)} "
  puts "---+---+---"
  puts " #{display_symbol(3)} | #{display_symbol(4)} | #{display_symbol(5)} "
  puts "---+---+---"
  puts " #{display_symbol(0)} | #{display_symbol(1)} | #{display_symbol(2)} \n"
end

def display_symbol(index)
  case $arr[index]
  when true then "O"
  when false then "X"
  else $arr[index]
  end
end

def check_winner
  wins = [
    [0,1,2], [3,4,5], [6,7,8],
    [0,3,6], [1,4,7], [2,5,8],
    [0,4,8], [2,4,6]
  ]

  wins.each do |combo|
    if $arr[combo[0]] == $arr[combo[1]] && $arr[combo[1]] == $arr[combo[2]]
      display
      puts "Player #{$arr[combo[0]] ? 'O' : 'X'} Won!"
      $new_game = true
      return
    end
  end
end

def start_game
  loop do
    display
    print "Player #{$player ? 'O' : 'X'}, enter a position (1-9): "
    input = gets.chomp.to_i - 1

    if input.between?(0, 8) && $arr[input].is_a?(Integer)

      $arr[input] = $player
      check_winner

      if $new_game
        print "Play again? (y/n): "
        ans = gets.chomp.downcase
        if ans == "y"
          reset_game
          $new_game = false
          next
        else
          break
        end
      end

      $player = !$player

      if $arr.none? { |x| x.is_a?(Integer) }
        display
        puts "It's a draw!"

        print "Play again? (y/n): "
        ans = gets.chomp.downcase
        if ans == "y"
          reset_game
          next
        else
          break
        end
      end
    else
      puts "Invalid move, try again."
    end
  end
end

start_game