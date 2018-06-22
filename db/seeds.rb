require 'rest-client'
require 'pry'
require 'nokogiri'
require 'faker'
# require_relative '../config/environment'

def scrap
  pg = 194
  while pg < 200
    url = "https://www.zoopla.co.uk/to-rent/property/london/?identifier=london&q=London&search_source=home&radius=0&price_frequency=per_month&pn="+ pg.to_s
    page = Nokogiri::HTML(RestClient.get(url))
    new_page = page.css('div.listing-results-wrapper')
    i = 0
    while i < new_page.length
      begin
        address = new_page[i].css('a.listing-results-address').text
        postcode = address.split.last
        description = new_page[i].css('p').first.text.strip
        price = new_page[i].css('a').text.split[1].chomp[1..6].gsub(/,/, '').to_i
        bedroom_element = new_page[i].css('span.num-icon')
        num_bedrooms = bedroom_element ? bedroom_element.attribute('title').value.split[0].to_i : 0
        bath_element = new_page[i].css('span.num-baths')
        num_bath =  bath_element ? bath_element.attribute('title').value.split[0].to_i : 0
        listing_url = "https://www.zoopla.co.uk/" + new_page[i].css('a').attribute('href').value

        new_listing = Listing.create(address: address,
                  postcode: postcode,
                  num_bedrooms: num_bedrooms,
                  num_bathrooms: num_bath,
                  price: price,
                  short_description: description,
                  url: listing_url)
            i += 1
          rescue
            i += 1
        end
        pg += 1
    end
  end
end

scrap


$neigh = ["Hampstead", "Chelsea", "Clapham", "Victoria", "Shoreditch", "Canary Wharf", "Soho", "Camden", "Islington", "Fulham"]
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
#
# megahood
