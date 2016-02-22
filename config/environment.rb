require 'bundler/setup'
Bundler.require

DB = {:conn => SQLite3::Database.new("database/cocktail.db")}

require_all 'app'