class HumanPlayer < Player

  def guess_colors
    pick_color_message
    pick_colors
  end

  def pick_secret_colors
    pick_color_message
    pick_colors
  end

  def pick_color_message
    puts "color choices: #{game.colors.join(', ')}"
    puts "please pick 4 colors. Hit enter after typing each color picked."
  end

  def pick_colors
    choices = []
    1.upto(4) do |i|
      puts "Color number #{i}"
      color = gets.strip.downcase
      unless valid_color?(color)
        puts "Not a valid color"
        redo
      end
      choices << color
    end
    choices
  end

  def valid_color?(input)
    game.colors.each do |color|
      return true if color == input
    end
    false
  end
end