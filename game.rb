class Game
  attr_reader :maker, :breaker, :colors, :matches, :round_counter
  def initialize
    @secret_colors = []
    @matches = {}
    @round_counter = 0
    @colors = ["red", "blue", "green", "yellow", "black", "white"]
  end

  def play
    ask_player_role
    set_roles(player_role_selection)
    @secret_colors = maker.pick_secret_colors
    loop do 
      @round_counter += 1
      guessed_colors = breaker.guess_colors
      puts "#{breaker.name.capitalize} guessed #{guessed_colors}"
      @matches = find_matches(guessed_colors)
    
      if game_over
        puts game_over_message
        return
      else
        feedback
      end
    end
  end

  def ask_player_role
    puts "If you want to be a codemaker, please type 1 and hit enter."
    puts "If you want to be a  codebreaker, please type 2 and hit enter"
  end

  def player_role_selection(selection = gets.chomp.to_i)
    until selection == 1 || selection == 2
      puts "Please enter a valid option"
      ask_player_role
      selection = player_role_selection
    end
    selection
  end

  def set_roles(selection)
    if selection == 1
      @maker = HumanPlayer.new(self, "you")
      @breaker = ComputerPlayer.new(self, "computer")
      puts "You selected to be the codemaker."
    else
      @maker = ComputerPlayer.new(self, "computer")
      @breaker = HumanPlayer.new(self, "you")
      puts "You selected to be the codebreaker"
    end
  end

  def find_matches(guess)
    index_and_color_matches = find_index_and_color_match(guess)
    color_matches = find_color_match(guess)
    color_matches -= index_and_color_matches if index_and_color_matches > 0
    {index_and_color: index_and_color_matches, color: color_matches}
  end

  def find_index_and_color_match (guess)
    match = 0
    arr = [@secret_colors, guess]
    arr.transpose.each { |set| match += 1 if set[0] == set[1] }
    match   
  end

  def find_color_match(guess)
    match = 0
    colors = @secret_colors.map { |color| color }
    guess.each do |value| 
      if colors.include?(value)
        match += 1
        colors.slice!(colors.index(value), 1)
        next 
      end
    end
    match
  end

  def feedback
    puts "#{matches[:index_and_color]} correct color(s) in correct position"
    puts "#{matches[:color]} correct color(s) in wrong position" 
    puts "#{12 - round_counter} attempt(s) left"
  end

  def game_over
    return :broken if matches[:index_and_color] == 4
    return :unbroken if round_counter == 12
    false
  end

  def game_over_message
    if game_over == :broken 
      return "#{breaker.name.capitalize} broke the code in #{round_counter} attempts!" 
    else 
      return "Game Over... #{breaker.name.capitalize} coudn't break the code!" 
    end
  end
end