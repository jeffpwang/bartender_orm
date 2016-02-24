class CocktailController

  def display_menu
    new_menu = CocktailNewView.new
    new_menu.display_menu
  end 

  def list_all
    new_list = CocktailNewView.new
    new_list.list_all
  end 

  def all_cocktails
    DB[:conn].execute("SELECT cocktails.name FROM cocktails")  
  end 
    
  def prompt_cocktail
    new_selection = CocktailNewView.new
    new_selection.select_cocktail
  end 

  def select_cocktail(response)
    cocktail_selection = self.all_cocktails.flatten[response.to_i - 1]
    find_spirits_mixers(cocktail_selection)
  end 

  def find_spirits_mixers(cocktail_selection)
    sql = <<-SQL 
    SELECT cocktails.name, spirits.name, mixers.name FROM cocktails 
    INNER JOIN cocktail_spirits 
    ON cocktails.id = cocktail_spirits.cocktail_id
    INNER JOIN spirits
    ON cocktail_spirits.spirit_id = spirits.id
    INNER JOIN cocktail_mixers
    ON cocktail_mixers.cocktail_id = cocktails.id
    INNER JOIN mixers
    ON cocktail_mixers.mixer_id = mixers.id
    WHERE cocktails.name = ?
    SQL
    
    spirits = []
    mixers = []
    cocktail = ''
    DB[:conn].execute(sql, cocktail_selection).map do |row| 
        cocktail = row[0]
        spirits << row[1]
        mixers << row[2]
    end 

    CocktailNewView.new.cocktail_selection_display(cocktail, spirits, mixers)
  end 

  def find_cocktail(spirit_answer, mixer_answer)
    sql = <<-SQL
    SELECT cocktails.name
    FROM cocktails
    INNER JOIN cocktail_spirits ON cocktails.id = cocktail_spirits.cocktail_id
    INNER JOIN spirits ON cocktail_spirits.spirit_ID = spirits.id
    INNER JOIN cocktail_mixers ON cocktail_mixers.cocktail_id = cocktails.id
    INNER JOIN mixers ON cocktail_mixers.mixer_id = mixers.id
    WHERE spirits.name = ? AND mixers.name = ? 
    SQL
  
    choices = DB[:conn].execute(sql, spirit_answer, mixer_answer).uniq.flatten
    CocktailNewView.new.show_user_cocktail(choices)
  end 


  def add_cocktail
    cocktail_name = CocktailNewAdd.new.add_cocktail_prompt
    Cocktail.create({:name => cocktail_name})
  end 

  def display_output(cocktail)
    cocktail_name = cocktail.name
    cocktail_spirits = cocktail.spirits.map {|spirit| spirit.name}
    cocktail_mixers = cocktail.mixers.map {|mixer| mixer.name}
    CocktailNewAdd.new.output(cocktail_name, cocktail_spirits, cocktail_mixers)
  end 

end