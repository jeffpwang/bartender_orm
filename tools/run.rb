require_relative '../config/environment.rb'


def reload!
    load('../config/environment.rb')
end 

Cocktail.drop_table
Spirit.drop_table
CocktailSpirit.drop_table

Cocktail.create_table
Spirit.create_table
CocktailSpirit.create_table 

cocktail_hash = 
    { "manhattan" => {:spirits => ["whiskey", "vermouth"]},
      "gin & tonic" => {:spirits =>["gin", "tonic"]}, 
      "negroni" => {:spirits => ["gin"]},
      "mai tai" => {:spirits => ["curacao"]},
      "juan collins" => {:spirits => ["tequila"]},
      "rum & coke" => {:spirits => ["rum"]}, 
      "old fashioned" => {:spirits => ["whiskey"]}, 
      "margarita" => {:spirits => ["tequila", "triple sec"]}, 
      "mint julep" => {:spirits => ["bourbon"]}, 
      "tom collins" => {:spirits => ["gin"]},
      "cosmopolitan" => {:spirits => ["vodka", "triple sec"]}
 }
 

cocktail_hash.each do |cocktail_name, cocktail_hash_data|
  new_cocktail = Cocktail.create({:name => cocktail_name})
  
  cocktail_hash_data[:spirits].each do |spirit|
        new_cocktail.add_spirit(spirit)
  end 
  
  new_cocktail.add_to_joiner

end 

    action = ''
    
    menu = "Select an action: 
            1 - List All Cocktails
            2 - Choose from Spirit
            3 - Add a Cocktail
            4 - Exit"
    
    while action != 'Exit' && action != '4' do
    
    puts menu
    
    action = gets.chomp
    
        case action 
        
        when '1' #List All Cocktails
         
          names = DB[:conn].execute("SELECT cocktails.name FROM cocktails")  
          names.flatten.each_with_index do |row, i|
            puts "#{i + 1}. #{row.capitalize}"
          end
          puts "\n\n"
        
            puts "Select the number corresponding to a cocktail to view its spirit(s)."
            cocktail_selection = gets.chomp 
            
            cocktail_selection = names.flatten[cocktail_selection.to_i - 1]
            
            sql = <<-SQL 
            SELECT cocktails.name, spirits.name FROM cocktails 
            INNER JOIN cocktail_spirits 
            ON cocktails.id = cocktail_spirits.cocktail_id
            INNER JOIN spirits
            ON cocktail_spirits.spirit_id = spirits.id
            WHERE cocktails.name = '#{cocktail_selection}'
            SQL
            
            spirits = []
            cocktail = ''
            DB[:conn].execute(sql).map do |row| 
                cocktail = row[0]
                spirits << row[1]
            end 
            
            puts "The #{cocktail.split.map(&:capitalize).join(' ')} has #{spirits.join(" and ")}."
        
        when '2' #Let user choose spirit
            puts "Which spirit would you like?"
            answer = gets.chomp
            sql = <<-SQL
            SELECT cocktails.name FROM cocktails
            INNER JOIN cocktail_spirits 
            ON cocktails.id = cocktail_spirits.cocktail_id
            INNER JOIN spirits ON spirits.id = cocktail_spirits.spirit_id
            WHERE spirits.name = ?
            SQL
            cocktail = []
            DB[:conn].execute(sql, answer.downcase).map do |row|
             cocktail << row
            end
             puts "Your cocktail choices are: #{cocktail.flatten.join(", ").upcase}."
        
            
        
        
        when '3'
          puts "What is the name of the cocktail you would like to add?"
          user_cocktail_name = gets.chomp 
          user_created_cocktail = Cocktail.create({:name => user_cocktail_name})
          
          puts "What type of spirit is in this cocktail?"
          user_spirit = gets.chomp 
          
          user_created_cocktail.add_spirit(user_spirit)
          
          another_spirit = 1
          
          while(another_spirit == 1)
            puts "Is there another spirit? Enter the name of the spirit or type 'no'"
            next_spirit = gets.chomp
          
              if next_spirit == 'no'
                another_spirit = 2
              elsif
                user_created_cocktail.add_spirit(next_spirit)
              end
          end
          
            user_created_cocktail.add_to_joiner
           puts "You have created the #{user_created_cocktail.name.split.map(&:capitalize).join(' ')}!" 
    
           puts "\n\n"
  
        end
        
      
    end




