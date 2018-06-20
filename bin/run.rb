require_relative '../config/environment'
require 'rest-client'
require 'json'
require 'pry'
require 'nokogiri'
require 'active_support/core_ext'

# xml_file = File.read("http://api.zoopla.co.uk/api/v1/property_listings.xml?area=London&api_key=t926ms4qbmuhsewrh9fnr65a&page_size=10&page_number=99")
response = RestClient.get("http://api.zoopla.co.uk/api/v1/property_listings.xml?area=London&api_key=t926ms4qbmuhsewrh9fnr65a&page_size=10&page_number=99")
data = Hash.from_xml(response)

Listing.new(address: )


puts "HELLO WORLD"
