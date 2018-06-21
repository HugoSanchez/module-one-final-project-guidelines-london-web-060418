require 'rest-client'
require 'pry'
require 'nokogiri'
# require_relative '../config/environment'
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
  while i < 100
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

$large_number_range = (1000..20000).to_a
$neigh = ["Hampstead", "Chelsea", "Clapham", "Victoria", "Shoreditch", "Canary Wharf", "Soho", "Camden", "Islington", "Fulham"]

def fakemega
  address = Faker::Address
  Listing.create(address: address.full_address,
              postcode: address.postcode,
              neighborhood: $neigh.sample,
              listing_status: "Rent",
              property_type: ["Flat", "House"].sample,
              num_bedrooms: (1..10).to_a.sample,
              num_bathrooms: (1..5).to_a.sample,
              price: $large_number_range.sample,
              # short_description: "Whatever",
              listing_date: DateTime.now)
  puts "Created fake listing"
end

500.times do
  fakemega
end

$restaurants = ["Some", "Some, but crappy", "Plenty of", "Family Friendly", "Only a few", "No"]
$parks = ["No", "Some", "A few nice", "Plenty of", "Playgrounds and"]
$pt = ["Very well connected", "Very well connected", "Very well connected", "Very well connected", "Poorly connected"]
$age = ["15-25", "20-35", "35-50", "50+"]

def megahood
  $neigh.each do |n|
  Neighborhood.create(name: n,
                      public_schools: (1..5).to_a.sample,
                      crime_rate: (1..7).to_a.sample,
                      restaurants: $restaurants.sample,
                      parks: $parks.sample,
                      public_transport: $pt.sample,
                      average_age: $age.sample)
  end
end

megahood
