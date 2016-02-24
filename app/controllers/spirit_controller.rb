class SpiritController  
  
  def user_choice
    spirit_answer = SpiritNewView.new.prompt_user
    spirit_answer
  end 

  def find_cocktail_from_spirits(spirit_answer)
    sql = <<-SQL
    SELECT cocktails.name FROM cocktails
    INNER JOIN cocktail_spirits 
    ON cocktails.id = cocktail_spirits.cocktail_id
    INNER JOIN spirits ON spirits.id = cocktail_spirits.spirit_id
    WHERE spirits.name = ?
    SQL
    
    cocktail_array = []
    DB[:conn].execute(sql, spirit_answer).map do |row|
     cocktail_array << row
    end
    cocktail_array
  end 

  def find_matching_mixers(cocktails)
    MixerController.new.display_mixers(cocktails)
  end 

  def add_spirit
    SpiritNewAdd.new.add_spirit_prompt
  end 

  def add_another_spirit
    SpiritNewAdd.new.add_another_spirit_prompt
  end 

end