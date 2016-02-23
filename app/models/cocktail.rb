class Cocktail
    
    attr_accessor :name, :spirits, :id, :mixers
  

    @@all = []
    
    def initialize(attributes)
        @name = attributes[:name] 
        @spirits = []
        @mixers = []
        @@all << self
    end 
    
    def self.create_table
        sql = <<-SQL 
        CREATE TABLE IF NOT EXISTS cocktails (
        id INTEGER PRIMARY KEY,
        name TEXT   
        )
        SQL
        
        DB[:conn].execute(sql)
    end
     
            
    def save
        if self.id
            self.update
        else
            sql = <<-SQL
            INSERT INTO cocktails (name)
            VALUES (?)
            SQL
            DB[:conn].execute(sql, self.name)
            @id = DB[:conn].execute("SELECT last_insert_rowid() FROM cocktails")[0][0]
        end
    end
    
    def self.create(attributes)
        cocktail = self.new(attributes)
        cocktail.save
        cocktail
    end
    
    def self.new_from_db(row)
        cocktail = self.new({:name => row[1]})
        cocktail.id = row[0]
        cocktail
    end
    
    def self.find_by_name(name)
        sql = <<-SQL
        SELECT * FROM cocktails WHERE name = ?
        SQL
        
        DB[:conn].execute(sql, name).map do |row| 
            self.new_from_db(row)
        end.first
    end
    
    def self.all
      sql = <<-SQL
      SELECT *
      FROM cocktails
      SQL
 
      DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
      end
    end
    
    def update
        sql = <<-SQL
        UPDATE cocktails SET name = ? WHERE ID = ?
        SQL
        DB[:conn].execute(sql, self.name,  self.id)
    end
    
    def self.find_by_id(id)
        sql = "SELECT * FROM cocktails WHERE id = ?"
        
        DB[:conn].execute(sql, id).map do |row| 
            self.new_from_db(row)
        end.first
    end
    
    def add_spirit(spirit_name)  
        new_spirit = Spirit.create({:name => spirit_name})
        new_spirit.cocktails << self
        self.spirits << new_spirit
        new_spirit
    end 
    
    def add_mixer(mixer_name)
        new_mixer = Mixer.create({:name => mixer_name})
        new_mixer.cocktails << self
        self.mixers << new_mixer
        new_mixer
    end
    
    def self.drop_table
        sql = <<-SQL
        DROP TABLE IF EXISTS cocktails
        SQL
        
        DB[:conn].execute(sql)
    end
    
    def add_to_spirit_joiner
        spirit_array = []
        self.spirits.each do |spirit| 
           spirit_array << spirit.id
        end 
        
        spirit_array.each do |spirit_id| 
            CocktailSpirit.create({:cocktail_id => self.id, :spirit_id => spirit_id}) 
        end
    end 
    
    def add_to_mixer_joiner
        mixer_array = []
        self.mixers.each do |mixer| 
           mixer_array << mixer.id
        end 
        
        mixer_array.each do |mixer_id| 
            CocktailMixer.create({:cocktail_id => self.id, :mixer_id => mixer_id}) 
        end
    end 
    
    
    
end
