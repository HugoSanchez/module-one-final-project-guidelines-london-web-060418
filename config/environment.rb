require 'bundler'
require 'rest-client'
require 'json'
require 'pry'
require 'nokogiri'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

ActiveRecord::Base.logger = nil     # hides the SQL transaction outputs off console 
