class MixerController

  def display_mixers(cocktails)
    mixers = find_mixers_from_cocktails(cocktails)
    user_mixer = MixerNewView.new.display_mixers(mixers)
    user_mixer
  end 

  def find_mixers_from_cocktails(cocktails)
    mixers_array = [] 
    cocktails.each do |cocktail|
      sql = <<-SQL
      SELECT mixers.name FROM cocktails
      INNER JOIN cocktail_mixers ON cocktails.id = cocktail_mixers.cocktail_id
      INNER JOIN mixers ON mixers.id = cocktail_mixers.mixer_id
      WHERE cocktails.name = ?
      SQL
      
      DB[:conn].execute(sql, cocktail).map do |row|
      mixers_array << row
      end
    end 
    mixers_array
  end 

  def add_mixer
    MixerNewAdd.new.add_mixer_prompt
  end 

  def add_another_mixer
    MixerNewAdd.new.add_another_mixer_prompt
  end 
  

end