class CocktailSpirit
   attr_accessor :cocktail_id, :spirit_id, :id
   @@all = []
   
    def initialize(attributes)
        @cocktail_id = attributes[:cocktail_id]
        @spirit_id = attributes[:spirit_id]
        @@all << self
    end
    
    def self.create(attributes)
        new_cocktail_spirit = CocktailSpirit.new(attributes)
        new_cocktail_spirit.save
        new_cocktail_spirit
    end
    
    def self.create_table
        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS cocktail_spirits (
        id INTEGER PRIMARY KEY,
        cocktail_id INTEGER,
        spirit_id INTEGER)
        SQL
        
        DB[:conn].execute(sql)
    end
    
    def save
        if self.id
            self.update
        else
        sql = <<-SQL
        INSERT INTO cocktail_spirits (cocktail_id, spirit_id) VALUES (?, ?)
        SQL
        
        DB[:conn].execute(sql, self.cocktail_id, self.spirit_id)
        @id = DB[:conn].execute("SELECT last_insert_rowid() from cocktail_spirits")[0][0]
        end
    end
    
    def update 
        sql = <<-SQL
        UPDATE cocktail_spirits SET cocktail_id = ?, spirit_id = ? WHERE id = ?
        SQL
        
        DB[:conn].execute(sql, self.cocktail_id, self.spirit_id, self.id)
    end
    
    def self.all
        @@all
    end
    
    
    def create(cocktail_id, spirit_id)
        new_cocktailspirit = CocktailSpirit.new(cocktail_id, spirit_id)
        new_cocktailspirit.save
        new_cocktailspirit
    end
    
    def find_by_spirit(spirt_id)
        # find the cocktails by spirit, returns cocktail id
                sql = <<-SQL
    SELECT cocktail_id FROM cocktail_spirits
    WHERE spirit_id = ?
    SQL

    DB[:conn].execute(sql,spirit_id)
            
    end
        
        
    
    def return_spirit_id(cocktail_id)
         # return spirit id
        
          sql = <<-SQL
    SELECT spirit_id FROM cocktail_spirits
    WHERE cocktail_id = ?
    SQL

    DB[:conn].execute(sql,cocktail_id)
    end
    
    def return_spirit_name(cocktail_id)
         # return spirit name
         id_of_spirit = return_spirit_id(cocktail_id)
         id_of_spirit.name
    end
    
      def self.drop_table
        sql = <<-SQL
        DROP TABLE IF EXISTS cocktail_spirits
        SQL
        
        DB[:conn].execute(sql)
    end

end