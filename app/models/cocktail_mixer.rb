class CocktailMixer
   attr_accessor :cocktail_id, :mixer_id, :id
   @@all = []
   
    def initialize(attributes)
        @cocktail_id = attributes[:cocktail_id]
        @mixer_id = attributes[:mixer_id]
        @@all << self
    end
    
    def self.create(attributes)
        new_cocktail_mixer = CocktailMixer.new(attributes)
        new_cocktail_mixer.save
        new_cocktail_mixer
    end
    
    def self.create_table
        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS cocktail_mixers (
        id INTEGER PRIMARY KEY,
        cocktail_id INTEGER,
        mixer_id INTEGER)
        SQL
        
        DB[:conn].execute(sql)
    end
    
    def save
        if self.id
            self.update
        else
        sql = <<-SQL
        INSERT INTO cocktail_mixers (cocktail_id, mixer_id) VALUES (?, ?)
        SQL
        
        DB[:conn].execute(sql, self.cocktail_id, self.mixer_id)
        @id = DB[:conn].execute("SELECT last_insert_rowid() from cocktail_mixers")[0][0]
        end
    end
    
    def update 
        sql = <<-SQL
        UPDATE cocktail_mixers SET cocktail_id = ?, mixer_id = ? WHERE id = ?
        SQL
        
        DB[:conn].execute(sql, self.cocktail_id, self.mixer_id, self.id)
    end
    
    def self.all
        @@all
    end
    
    
    def create(cocktail_id, mixer_id)
        new_cocktailmixer = CocktailMixer.new(cocktail_id, mixer_id)
        new_cocktailmixer.save
        new_cocktailmixer
    end
    
    def find_by_mixer(mixer_id)
        sql = <<-SQL
        SELECT cocktail_id FROM cocktail_mixers
        WHERE mixer_id = ?
        SQL
    
        DB[:conn].execute(sql, mixer_id)
            
    end
        
        
    
    def return_mixer_id(cocktail_id)
        sql = <<-SQL
        SELECT mixer_id FROM cocktail_mixers
        WHERE cocktail_id = ?
        SQL

        DB[:conn].execute(sql,cocktail_id)
    end
    
    
    def return_mixer_name(cocktail_id)
         id_of_mixer = return_mixer_id(cocktail_id)
         id_of_mixer.name
    end
    
    def self.drop_table
        sql = <<-SQL
        DROP TABLE IF EXISTS cocktail_mixers
        SQL
        
        DB[:conn].execute(sql)
    end

end