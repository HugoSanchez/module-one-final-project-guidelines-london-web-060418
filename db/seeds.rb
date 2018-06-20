require 'rest-client'
require 'pry'
require 'nokogiri'
require "active_support/core_ext"
require 'faker'

# def get_data
#   response = RestClient.get('http://api.zoopla.co.uk/api/v1/property_listings.xml?area=London&api_key=fs6fgwkdczua7fxawra4af6u&page_size=10&page_number=99')
#   Hash.from_xml(response)
# end
#
# # def parse_data
# #   array = []
# #   get_data["response"]["listing"].each do |element|
# #     array << element["displayable_address"]
# #   end
# #   array   #of addresses
# # end
#
# def first_listing
#   get_data["response"]["listing"].each do |element|
#     Listing.create(address: element["displayable_address"],
#                 postcode: element["outcode"],
#                 listing_status: element["listing_status"],
#                 property_type: element["property_type"],
#                 num_bedrooms: element["num_bedrooms"].to_i,
#                 num_bathrooms: element["num_bathrooms"].to_i,
#                 price: element["price"].to_i,
#                 short_description: element["short_description"],
#                 listing_date: DateTime.strptime(element["first_published_date"], '%Y-%m-%d %H:%M:%S'))
#               end
#
# end

def megamaster

  i = 1
  while i < 50
    url = "http://api.zoopla.co.uk/api/v1/property_listings.xml?area=London&api_key=v3h9peepc3wqc655298kt63u&page_size=100&page_number="+"#{i}"

    resp = RestClient.get(url)
    data = Hash.from_xml(resp)

    data["response"]["listing"].each do |element|
      Listing.create(address: element["displayable_address"],
                  postcode: element["outcode"],
                  listing_status: element["listing_status"],
                  property_type: element["property_type"],
                  num_bedrooms: element["num_bedrooms"].to_i,
                  num_bathrooms: element["num_bathrooms"].to_i,
                  price: element["price"].to_i,
                  short_description: element["short_description"],
                  listing_date: DateTime.strptime(element["first_published_date"], '%Y-%m-%d %H:%M:%S'))
                end

      i += 1

    end

end

$large_number_range = (200000..20000000).to_a

def fakemega
  address = Faker::Address
  Listing.create(address: address.full_address,
              postcode: address.postcode,
              listing_status: "Sale",
              property_type: ["Flat", "House"].sample,
              num_bedrooms: (0..10).to_a.sample,
              num_bathrooms: (0..10).to_a.sample,
              price: $large_number_range.sample,
              short_description: "Whatever",
              listing_date: DateTime.now)
  puts "Created fake listing"
end

100.times do
  fakemega
end
