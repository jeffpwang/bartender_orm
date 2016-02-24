require_relative '../config/environment.rb'
require_relative 'seed'


def reload!
    load('../config/environment.rb')
end 


action = ''

while action != 'Exit' && action != '4' do

CocktailController.new.display_menu

action = gets.chomp

  case action 
    
    when '1' #List All Cocktails
     
      CocktailController.new.list_all
      CocktailController.new.prompt_cocktail
    
    when '2' #Let user choose spirit and mixer       

      spirit_answer = SpiritController.new.user_choice
      cocktail_array = SpiritController.new.find_cocktail_from_spirits(spirit_answer)
      mixer_answer = SpiritController.new.find_matching_mixers(cocktail_array)
      CocktailController.new.find_cocktail(spirit_answer, mixer_answer)  
    
    when '3' #User adds cocktail

      user_created_cocktail = CocktailController.new.add_cocktail

      user_spirit = SpiritController.new.add_spirit
      user_created_cocktail.add_spirit(user_spirit)
      
      another_spirit = ''
      
      until another_spirit == 'no'
        another_spirit = SpiritController.new.add_another_spirit
        user_created_cocktail.add_spirit(another_spirit) unless another_spirit == 'no'
      end

      user_mixer = MixerController.new.add_mixer
      user_created_cocktail.add_mixer(user_mixer)
      
      another_mixer = ''

      until another_mixer == 'no'
        another_mixer = MixerController.new.add_another_mixer
        user_created_cocktail.add_mixer(another_mixer) unless another_mixer == 'no'
      end
    
      user_created_cocktail.add_to_spirit_joiner
      user_created_cocktail.add_to_mixer_joiner

      CocktailController.new.display_output(user_created_cocktail)

   end 
    
  
end




