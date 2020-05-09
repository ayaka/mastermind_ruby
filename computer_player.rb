
class ComputerPlayer < Player

  attr_reader :possible_colors, :guess, :confirmed_colors

  def initialize(game, name)
    super(game, name)
    @possible_colors = game.colors.map { |color| color }
    @guess = []
    @confirmed_colors = []
  end

  def guess_colors
    pick_color_message("guessing")
    return pick_guess_colors if game.round_counter == 1
    
    if game.matches.values.reduce(:+) == 4
      guess.shuffle
    else
      new_matches = game.matches.values.reduce(:+) - confirmed_colors.length
      if new_matches == 0
        pick_guess_colors
      else
        new_matches.times { @confirmed_colors << guess[3] }
        pick_guess_colors
      end
    end
  end

  def pick_color_message (text)
    puts "#{name.capitalize} is #{text} colors"
    rand(3..7).times do
      print "."
      sleep 1
    end
    puts "Done"
    sleep 1
  end

  def pick_guess_colors
    @possible_colors = possible_colors.reject { |color| color == guess[3] }
    new_color = possible_colors.sample
    3.downto(confirmed_colors.length) { |i| guess[i] = new_color }  
    guess
  end

  def pick_secret_colors
    pick_color_message("picking secret")
    choices = (1..4).map { |i| game.colors.sample }
  end

end
