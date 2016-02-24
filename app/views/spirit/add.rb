class SpiritNewAdd

  def add_spirit_prompt
    puts "What type of spirit is in this cocktail?"
    user_spirit = gets.chomp.downcase
  end 

  def add_another_spirit_prompt
    puts "Is there another spirit? Enter the name of the spirit or type 'no'"
    next_spirit = gets.chomp.downcase
  end 

end 