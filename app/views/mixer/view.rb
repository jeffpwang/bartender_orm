class MixerNewView

  def display_mixers(mixers)
    puts "Your mixer choices are: #{mixers.flatten.join(", ").upcase}."
    puts "Please pick a mixer"
    mixer_answer = gets.chomp.downcase
  end 

end 