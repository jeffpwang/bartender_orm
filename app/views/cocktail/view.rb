class CocktailNewView

  def display_menu
   puts "Select an action: 
        1 - List All Cocktails
        2 - Choose from Spirit and Mixer
        3 - Add a Cocktail
        4 - Exit"
  end 

  def list_all
    cocktail_list = DB[:conn].execute("SELECT cocktails.name FROM cocktails")  
    cocktail_list.flatten.each_with_index do |row, i|
      puts "#{i + 1}. #{row.capitalize}"
    end
    puts "\n\n"
  end 

  def select_cocktail
    puts "Select the number corresponding to a cocktail to view its spirit(s)."
    user_cocktail_selection = gets.chomp 
    CocktailController.new.select_cocktail(user_cocktail_selection)
  end 

  def cocktail_selection_display(cocktail, spirits, mixers)
    puts "The #{cocktail.split.map(&:capitalize).join(' ')} has: #{spirits.uniq.join(", ")}, #{mixers.uniq.join(", ")}."
    puts "\n\n"
  end 

  def show_user_cocktail(choices)
    puts "Your choices are: #{choices.join(", ").upcase}"
    puts "\n\n"
  end 

end 