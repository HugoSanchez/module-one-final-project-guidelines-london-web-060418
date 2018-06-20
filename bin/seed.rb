require 'rest-client'
require 'pry'
require 'nokogiri'
require "active_support/core_ext"


def get_data
  response = RestClient.get('http://api.zoopla.co.uk/api/v1/property_listings.xml?area=London&api_key=t926ms4qbmuhsewrh9fnr65a&page_size=10&page_number=99')
  Hash.from_xml(response)
end

def parse_data
  array = []
  get_data["response"]["listing"].each do |element|
    array << element["displayable_address"]
  end
  array   #of addresses
end
