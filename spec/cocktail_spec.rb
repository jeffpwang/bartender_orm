require "spec_helper"
require 'pry'

describe "Cocktail" do 

  let(:manhattan) {Cocktail.new("manhattan")}

  before(:each) do 
    DB[:conn].execute("DROP TABLE IF EXISTS cocktails")
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS cocktails (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        )
    SQL
    DB[:conn].execute(sql) 
  end

  describe "attributes" do 
    it 'has a name and a grade' do 
      manhattan= Cocktail.new("manhattan")
      expect(cocktail.name).to eq("manhattan")
    end

    it 'has an id that defaults to `nil` on initialization' do 
      expect(manhattan.id).to eq(nil)
    end
  end

  describe "#create_table" do 
    it 'creates the cocktail table in the database' do
      cocktail.create_table 
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='cocktails';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(['cocktails'])
    end
  end

  describe "#drop_table" do 
    it 'drops the cocktails table from the database' do 
      cocktail.drop_table
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='cocktails';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(nil)
    end
  end

  describe "#save" do 
    it 'saves an instance of the Cocktail class to the database and then sets the given cocktails `id` attribute' do 
      gin_tonic = Cocktail.new("gin and tonic")
      gin_tonic.save
      expect(DB[:conn].execute("SELECT * FROM cocktails")).to eq([[1, "gin and tonic"]])
      expect(gin_tonic.id).to eq(1)
    end
  end

  describe "#create" do 
    it 'takes in a hash of attributes and uses metaprogramming to create a new cocktail object. Then it uses the #save method to save that cocktail to the database' do 
      cocktail.create(name: "manhattan")
      expect(DB[:conn].execute("SELECT * FROM cocktails")).to eq([[1, "manhattan"]])
    end
  end

  describe '#new_from_db' do
    it 'creates an instance with corresponding attribute values' do
      row = [1, "screwdriver"]
      screwdriver = Cocktail.new_from_db(row)

      expect(screwdriver.id).to eq(row[0])
      expect(screwdriver.name).to eq(row[1])
    end
  end

  describe '#find_by_name' do
    it 'returns an instance of cocktail that matches the name from the DB' do
      manhattan.save
      manhattan_from_db = cocktail.find_by_name("manhattan")
      expect(manhattan_from_db.name).to eq("manhattan")
      expect(manhattan_from_db).to be_an_instance_of(Cocktail)
    end
  end

  describe '#update' do
    it 'updates the record associated with a given instance' do 
      manhattan.save
      manhattan.name = "manhattan with rye"
      manhattan.update
      manhattan_2 = cocktail.find_by_name("manhattan with rye")
      expect(manhattan_2.id).to eq(manhattan.id)
    end 
  end
end 