require_relative '../config/environment.rb'
require_relative 'seed'


def reload!
    load('../config/environment.rb')
end 


    action = ''
    
    menu = "Select an action: 
            1 - List All Cocktails
            2 - Choose from Spirit and Mixer
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
            SELECT cocktails.name, spirits.name, mixers.name FROM cocktails 
            INNER JOIN cocktail_spirits 
            ON cocktails.id = cocktail_spirits.cocktail_id
            INNER JOIN spirits
            ON cocktail_spirits.spirit_id = spirits.id
            INNER JOIN cocktail_mixers
            ON cocktail_mixers.cocktail_id = cocktails.id
            INNER JOIN mixers
            ON cocktail_mixers.mixer_id = mixers.id
            WHERE cocktails.name = '#{cocktail_selection}'
            SQL
            
            spirits = []
            mixers = []
            cocktail = ''
            DB[:conn].execute(sql).map do |row| 
                cocktail = row[0]
                spirits << row[1]
                mixers << row[2]
            end 
            
            puts "The #{cocktail.split.map(&:capitalize).join(' ')} has: #{spirits.uniq.join(", ")}, #{mixers.uniq.join(", ")}."
        
        when '2' #Let user choose spirit and mixer
        
            puts "Which spirit would you like?"
            spirit_answer = gets.chomp.downcase
            
            sql = <<-SQL
            SELECT cocktails.name FROM cocktails
            INNER JOIN cocktail_spirits 
            ON cocktails.id = cocktail_spirits.cocktail_id
            INNER JOIN spirits ON spirits.id = cocktail_spirits.spirit_id
            WHERE spirits.name = ?
            SQL
            
            cocktail_array = []
            mixers_array = [] 
            DB[:conn].execute(sql, spirit_answer.downcase).map do |row|
             cocktail_array << row
            end
            
            cocktail_array.each do |cocktail|
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
            
            puts "Your mixer choices are: #{mixers_array.flatten.join(", ").upcase}."
            puts "Please pick a mixer"
            mixer_answer = gets.chomp.downcase
            
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
            puts "Your choices are: #{choices.join(", ").upcase}"
          
        
        when '3' #User adds cocktail
        
          puts "What is the name of the cocktail you would like to add?"
          user_cocktail_name = gets.chomp 
          user_created_cocktail = Cocktail.create({:name => user_cocktail_name})
          
          puts "What type of spirit is in this cocktail?"
          user_spirit = gets.chomp 
          
          user_created_cocktail.add_spirit(user_spirit)
          
          another_spirit = 'true'
          
          #adds spirits to db
          while(another_spirit == 'true')
            puts "Is there another spirit? Enter the name of the spirit or type 'no'"
            next_spirit = gets.chomp
          
              if next_spirit == 'no'
                another_spirit = 'false'
              elsif
                user_created_cocktail.add_spirit(next_spirit)
              end
          end
          
          
            #adds mixers to db
            another_spirit = 'true'
            
          puts "What mixers are in this cocktail?"
          user_mixer = gets.chomp 
              
          user_created_cocktail.add_mixer(user_mixer)
              
            while(another_spirit == 'true')
            puts "Is there another mixer? Enter the name of the mixer or type 'no'"
            next_mixer = gets.chomp
          
              if next_mixer == 'no'
                another_spirit = 'false'
              elsif
                user_created_cocktail.add_mixer(next_mixer)
              end
          end
          
            user_created_cocktail.add_to_spirit_joiner
            user_created_cocktail.add_to_mixer_joiner
           puts "You have created the #{user_created_cocktail.name.split.map(&:capitalize).join(' ')}!" 
    
           puts "\n\n"
  
        end
        
      
    end




