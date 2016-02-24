class MixerNewAdd

  def add_mixer_prompt
    puts "What mixers are in this cocktail?"
    user_mixer = gets.chomp 
  end 

  def add_another_mixer_prompt
    puts "Is there another mixer? Enter the name of the mixer or type 'no'"
    next_mixer = gets.chomp
  end 

end 