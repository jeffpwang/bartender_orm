class Spirit
    attr_accessor :name, :cocktails, :id

    
    @@all = []
    
    def initialize(attributes)
        @name = attributes[:name]
        @cocktails = []
        @@all << self
    end
    
    def self.create_table
        sql = <<-SQL
            CREATE TABLE IF NOT EXISTS spirits (
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
        spirits = self.find_by_name(attributes[:name])

        if !spirits.empty? 
            spirits.first
        else 
            spirit = self.new(attributes)
            spirit.save
            spirit
        end 
    end
    
    def self.new_from_db(row)
      spirit = self.new({:name => row[1]}) 
      spirit.id = row[0]
      spirit
    end


    def self.find_by_name(name)
        sql = <<-SQL
        SELECT * FROM spirits WHERE name = ?
        SQL
        DB[:conn].execute(sql, name).map do |row|
            self.new_from_db(row)
        end 
    end 

    def update
        sql = <<-SQL
        UPDATE spirits SET name = ? WHERE ID = ?
        SQL
        DB[:conn].execute(sql, self.name, self.id)
    end 
    
    def save
        if self.id
            self.update
        else
            sql = <<-SQL
            INSERT INTO spirits (name, id)
            VALUES (?, ?)
            SQL
        DB[:conn].execute(sql, self.name, self.id)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM spirits")[0][0]
        end
    end
    
    def self.drop_table
        sql = <<-SQL
          DROP TABLE IF EXISTS spirits;
          )
          SQL
        DB[:conn].execute(sql)
    end
    
    
end 