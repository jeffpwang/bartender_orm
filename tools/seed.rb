require_relative '../config/environment.rb'


classes = [Cocktail, Spirit, Mixer, CocktailSpirit, CocktailMixer]

def drop_table(classes)
  classes.each do |x|
    x.drop_table
  end 
end

def create_table(classes)
  classes.each do |x|
    x.create_table
  end 
end 

drop_table(classes) 
create_table(classes)

cocktail_hash = 
    { "manhattan" => {:spirits => ["whiskey"], :mixers => ["vermouth", "bitters"]},
      "gin & tonic" => {:spirits =>["gin"], :mixers => ["tonic"]}, 
      "negroni" => {:spirits => ["gin"], :mixers => ["vermouth", "campari"]},
      "mai tai" => {:spirits => ["rum", "curacao"], :mixers => ["grenadine", "pineapple juice", "orange juice"]},
      "juan collins" => {:spirits => ["tequila"], :mixers => ["lemon juice", "agave nectar", "club soda"]},
      "rum & coke" => {:spirits => ["rum"], :mixers => ["coke"]}, 
      "screwdriver" => {:spirits => ["vodka"], :mixers => ["orange juice"]}, 
      "old fashioned" => {:spirits => ["whiskey"], :mixers => ["simple syrup", "orange peel", "bitters"]}, 
      "margarita" => {:spirits => ["tequila"], :mixers => ["lime juice"]}, 
      "mint julep" => {:spirits => ["bourbon"], :mixers => ["mint", "sugar"]}, 
      "tom collins" => {:spirits => ["gin"], :mixers => ["lemon juice", "simple syrup"]},
      "cosmopolitan" => {:spirits => ["vodka"], :mixers => ["cranberry juice", "triple sec", "lime juice"]}
 }
 

cocktail_hash.each do |cocktail_name, cocktail_hash_data|
  new_cocktail = Cocktail.create({:name => cocktail_name})
  
  cocktail_hash_data[:spirits].each do |spirit|
        new_cocktail.add_spirit(spirit)
  end 
  
  cocktail_hash_data[:mixers].each do |mixer|
        new_cocktail.add_mixer(mixer)
  end 
  
  new_cocktail.add_to_spirit_joiner
  new_cocktail.add_to_mixer_joiner

end 
