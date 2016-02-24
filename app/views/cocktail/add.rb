class CocktailNewAdd

  def add_cocktail_prompt
    puts "What is the name of the cocktail you would like to add?"
    user_cocktail_name = gets.chomp.downcase 
  end 

  def output(cocktail, spirits, mixers)
    ingredients = []
    ingredients << spirits
    ingredients << mixers
    ingredients_display = ingredients.flatten.join(', ')
    puts "You have created the #{cocktail.split.map(&:capitalize).join(' ')}! It contains: #{ingredients_display}." 
    puts "\n\n"
  end 

end 