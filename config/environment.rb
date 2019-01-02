require 'bundler'
# require 'rest-client' (moved to gem file)
require 'pry'
require 'json'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
