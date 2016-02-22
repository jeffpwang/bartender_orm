require "spec_helper"
require 'pry'

describe "Spirit" do 

  let(:whiskey) {Spirit.new("whiskey")}

  before(:each) do 
    DB[:conn].execute("DROP TABLE IF EXISTS spirits")
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS spirits (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        )
    SQL
    DB[:conn].execute(sql) 
  end

  describe "attributes" do 
    it 'has a name and a grade' do 
      whiskey= Spirit.new("whiskey")
      expect(Spirit.name).to eq("whiskey")
    end

    it 'has an id that defaults to `nil` on initialization' do 
      expect(whiskey.id).to eq(nil)
    end
  end

  describe "#create_table" do 
    it 'creates the spirit table in the database' do
      Spirit.create_table 
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='spirits';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(['spirits'])
    end
  end

  describe "#drop_table" do 
    it 'drops the spirits table from the database' do 
      Spirit.drop_table
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='spirits';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(nil)
    end
  end

  describe "#save" do 
    it 'saves an instance of the Student class to the database and then sets the given students `id` attribute' do 
      gin = Spirit.new("gin")
      gin.save
      expect(DB[:conn].execute("SELECT * FROM spirits")).to eq([[1, "gin"]])
      expect(gin.id).to eq(1)
    end
  end

  describe "#create" do 
    it 'takes in a hash of attributes and uses metaprogramming to create a new spirit object. Then it uses the #save method to save that spirit to the database' do 
      Spirit.create(name: "whiskey")
      expect(DB[:conn].execute("SELECT * FROM spirits")).to eq([[1, "whiskey"]])
    end
  end

  describe '#new_from_db' do
    it 'creates an instance with corresponding attribute values' do
      row = [1, "vodka"]
      screwdriver = Spirit.new_from_db(row)

      expect(screwdriver.id).to eq(row[0])
      expect(screwdriver.name).to eq(row[1])
    end
  end

  describe '#find_by_name' do
    it 'returns an instance of spirit that matches the name from the DB' do
      whiskey.save
      whiskey_from_db = Spirit.find_by_name("whiskey")
      expect(whiskey_from_db.name).to eq("whiskey")
      expect(whiskey_from_db).to be_an_instance_of(Spirit)
    end
  end

  describe '#update' do
    it 'updates the record associated with a given instance' do 
      whiskey.save
      whiskey.name = "rye whiskey"
      whiskey.update
      whiskey_2 = Spirit.find_by_name("rye whiskey")
      expect(whiskey_2.id).to eq(whiskey.id)
    end 
  end
end 