describe 'CocktailSpirit' do 

  before(:each) do 
    DB[:conn].execute("DROP TABLE IF EXISTS cocktail_spirit")
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS cocktail_spirit (
        id INTEGER PRIMARY KEY, 
        cocktail_id INTEGER,
        spirit_id INTEGER
        )
    SQL
    DB[:conn].execute(sql) 
  end

  describe "attributes" do 
    it 'has an id that defaults to `nil` on initialization' do 
      expect(cocktail_spirit.id).to eq(nil)
    end
  end

  describe "#create_table" do 
    it 'creates the cocktail_spirit table in the database' do
      CocktailSpirit.create_table 
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='cocktail_spirit';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(['cocktail_spirit'])
    end
  end

  describe 'show' do 
    it 'shows a database entry for each cocktail'
    end 

    it 'each row has a cocktail_id associated with a spirit_id'
  end 


end 