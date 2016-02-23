class Mixer
    attr_accessor :name, :cocktails, :id

    
    @@all = []
    
    def initialize(attributes)
        @name = attributes[:name]
        @cocktails = []
        @@all << self
    end
    
    def self.create_table
        sql = <<-SQL
            CREATE TABLE IF NOT EXISTS mixers (
                id INTEGER PRIMARY KEY,
                name TEXT
                )
                SQL
            DB[:conn].execute(sql)
        @name = name
        @@all << self
    end 
    
    def self.all
        @@all
    end 
    
    def self.create(attributes)
        mixers = self.find_by_name(attributes[:name])

        if !mixers.empty? 
            mixers.first
        else 
            mixer = self.new(attributes)
            mixer.save
            mixer
        end 
    end
    
    def self.new_from_db(row)
      mixer = self.new({:name => row[1]}) 
      mixer.id = row[0]
      mixer
    end


    def self.find_by_name(name)
        sql = <<-SQL
        SELECT * FROM mixers WHERE name = ?
        SQL
        DB[:conn].execute(sql, name).map do |row|
            self.new_from_db(row)
        end 
    end 

    def update
        sql = <<-SQL
        UPDATE mixers SET name = ? WHERE ID = ?
        SQL
        DB[:conn].execute(sql, self.name, self.id)
    end 
    
    def save
        if self.id
            self.update
        else
            sql = <<-SQL
            INSERT INTO mixers (name, id)
            VALUES (?, ?)
            SQL
        DB[:conn].execute(sql, self.name, self.id)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM mixers")[0][0]
        end
    end
    
    def self.drop_table
        sql = <<-SQL
          DROP TABLE IF EXISTS mixers;
          )
          SQL
        DB[:conn].execute(sql)
    end
    
    
end 