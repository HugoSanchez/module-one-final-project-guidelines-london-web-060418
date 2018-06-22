require_relative '../config/environment'
require 'pry'

class CLI

  @@hoods = ["Hampstead", "Chelsea", "Clapham", "Victoria", "Shoreditch", "Canary Wharf", "Soho", "Camden", "Islington", "Fulham"]
  @@postcodes = ["NW3", "SW10", "SW4", "SW1", "E1", "E14", "W1", "NW1", "N1", "SW6"]

  def start_cli
    spaces(30)
    greeting
    spaces(8)
    yes_no
    puts "Awesome!"
  end

  def spaces(num)
    num.times do
      puts ""
    end
  end

  def greeting
    puts "            Hello, please type your name here:"
    # system('say "Hello, please type your name here"')
    spaces(30)
    @name = gets.chomp.capitalize
    spaces(30)
    puts "            Hi #{@name}, welcome to London Property Listings, my name is Serious,
                      your personal assistant and I am going to help you find your perfect new home!"
    system("say 'Hi #{@name}, welcome to London Property Listings, my name is Serious, your personal assistant and I am going to help you find your perfect new home!'")
    @current_user = User.create(name: @name)
  end

    def yes_no
      system("say 'I am going to ask you a few questions to help you find the right place'")
      puts "               I'm going to ask you a few questions to help you find the right place."
      puts ""
      puts "                                        Shall we go ahead, #{@name}?"
      system("say 'Shall we go ahead, #{@name}?'")
      puts ""
      puts "                                                 Y - Yes!"
      puts ""
      puts "                                                 N - No."
      spaces(20)
      options(gets.chomp)
      spaces(30)
    end

  def options(choice)
      spaces(10)
      choice = choice.downcase
      if choice == "y"
        puts "                      Where would you like to LIVE?"
        system("say 'Where would you like to LIVE?'")
        spaces(5)
        select_area(@@hoods)
        # spaces(10)
        # choose_area
      elsif choice == "n"
        spaces(15)
        puts "            Hope to see you again soon, #{@name}!"
        system("say 'Hope to see you again soon, #{@name}!'")
      else
        puts "            Ooops...please type Y or N"
        system("say 'Ooops please type the correct command!'")
        choice = gets.chomp
        options(choice)
      end
  end

  def select_area(array)
    array.each_with_index do |neighborhood, i|
      puts "                              #{i+1} - #{neighborhood}"
      puts ""
    end
    spaces(5)
    choose_area
  end

  def choose_area
    puts "            Enter area number:"
    system("say 'Please, enter an area number'")
    @area_choice = gets.chomp.to_i
    @postcode = @@postcodes[@area_choice -1]
    @area_choice = @@hoods[@area_choice -1]

    spaces(30)
    puts "                 #{@area_choice} - great choice!"
    system("say '#{@area_choice} - great choice #{@name}!'")
    puts ""
    puts ""
    puts ""
    puts "                 Here's some information about this neighborhood:"
    system("say 'Here's some information about this neighborhood'")
    puts ""
    puts ""
    display_the_hood
  end

  def display_the_hood
    hood_choice = Neighborhood.find_by name: @area_choice
    system("say '#{@area_choice} has #{hood_choice.restaurants} restaurants.' ")
    puts "                 It has #{hood_choice.restaurants.downcase} restaurants."
    puts ""
    system("say 'It has #{hood_choice.parks} parks.'")
    puts "                 It has #{hood_choice.parks.downcase} parks."
    puts ""
    system("say 'Regarding public transport, #{@area_choice} is #{hood_choice.public_transport}'")
    puts "                 Regarding public transport, #{@area_choice} is #{hood_choice.public_transport.downcase}."
    puts ""
    system("say 'It has #{hood_choice.public_schools} public school(s)'")
    puts "                 It has #{hood_choice.public_schools} public school(s)."
    puts ""
    system("say 'The residents average age here is #{hood_choice.average_age}.'")
    puts "                 The residents average age here is #{hood_choice.average_age}."
    puts ""
    system("say 'Crime rate is #{hood_choice.crime_rate}, on a scale of 1-10' ")
    puts "                 Crime rate is #{hood_choice.crime_rate}, on a scale of 1-10 (low-high)."
    puts ""
    spaces(10)
    continue_to_bedrooms   #PRESS C to continue
  end

  def continue_to_bedrooms
    puts "PRESS C to continue"
    c = gets.chomp
    spaces(25)
    if c.downcase == "c"
      bedrooms
      spaces(25)
    else
      continue_to_bedrooms
    end
  end

  def bedrooms
    puts "                 How many bedrooms would you like?"
    system("say 'How many bedrooms would you like?'")
    spaces(5)
    puts "                 Enter a number between 1 and 10:"
    spaces(20)
    @num_bed = gets.chomp.to_i
    spaces(30)
    if @num_bed > 0 && @num_bed <= 10
      bathrooms
    else
      puts "                 Ooops...please enter a number between 1 and 10:"
      spaces(20)
      bedrooms
    end
  end

  def bathrooms
    puts "                 How many bathrooms would you like?"
    system("say 'How many bathrooms would you like?'")
    spaces(5)
    puts "                 Enter a number between 1 and 5:"
    spaces(20)
    @num_bath = gets.chomp.to_i
    spaces(30)
    if @num_bath > 0 && @num_bath < 6
      puts "                 Great! You chose #{@num_bed} bedrooms and #{@num_bath} bathrooms."
      system("say 'Great! You chose #{@num_bed} bedrooms and #{@num_bath} bathrooms.'")
      spaces(3)
      budget_question
    else
      puts "                 Ooops...please enter a number between 1 and 5:"
      spaces(20)
      bathrooms
    end
  end

  def budget_question
    puts "                 Now it's time for the REAL QUESTION:"
    system("say 'Now it's time for the REAL QUESTION'")
    puts ""
    puts "                         What is your budget?"
    system("say 'What is your budget #{@name}?'")
    puts ""
    budget
  end

  def budget
    puts "                 Please ENTER your monthly budget:"
    spaces(20)
    @user_budget = gets.chomp.to_i
    spaces(30)
    if @user_budget > 1000
      puts "                 Great! Your monthly budget is £#{@user_budget}."
      system("say 'Great! Your monthly budget is £#{@user_budget}'")
      spaces(5)
      show_listings
    elsif @user_budget > 0 && @user_budget < 1000
      puts "                 I'm afraid we don't have anything for less than £1,000 a month.

                                  You may want look for flat share options."
      puts ""
      puts ""
      budget
    elsif @user_budget == 0
      puts "                Ooops...please ENTER a number"
      spaces(10)
      budget
    end
  end

  def show_listings
    # Listing.where(:neighborhood => "Soho")
    @user_listings = Listing.where(:postcode => @postcode)
    @user_listings = @user_listings.select {|l| l.num_bedrooms == @num_bed}
    @user_listings = @user_listings.select {|l| l.num_bathrooms == @num_bath}
    @user_listings = @user_listings.select {|l| l.price < @user_budget}

    if @user_listings.length == 0
      puts "                 Sorry! We have no listings mathcing your criteria. Please try again!"
      system("say 'Sorry! We have no listings mathcing your criteria. Please try again!'")
      spaces(3)
      yes_no
    else
      puts "                 Awesome! We have #{@user_listings.length} listings for you:"
      system("say 'Awesome! We have #{@user_listings.length} listings for you:'")
      spaces(2)

      @user_listings.each do |listing|
        puts "                 Lisiting ID:   #{listing.id}"
        puts "                 *****************************"
        puts "                 Address: #{listing.address}"
        # puts listing.postcode
        puts "                 Bedrooms: #{listing.num_bedrooms}"
        puts "                 Bathrooms: #{listing.num_bathrooms}"
        puts "                 Price: £#{listing.price}"
        puts "                 Price: £#{listing.short_description}"
        puts "                 Property url: #{listing.url}"
        spaces(2)
      end
      continue_to_viewings
    end
  end

  def continue_to_viewings
    puts "PRESS V to arrange VIEWINGS:"
    c = gets.chomp
    spaces(2)
    if c.downcase == "v"
      view_intro_text
      spaces(30)
    else
      continue_to_viewings
    end
  end

  def view_intro_text
    puts "                 To arrange a viewing with us please ENTER the listing ID
                                and I will take care of it!"
    system("say 'To arrange a viewing with us please ENTER the listing ID and I will take care of it!'")
    puts ""
    puts "                            You can add as many as you like."
    system("say 'You can add as many as you like.'")
    puts ""
    puts "                 Once you've finished, PRESS 'F' to see your selection."
    spaces(15)
    arrange_viewing
  end

  def listing_input
    # get the input from the user
    input = gets.chomp
    # assume the input is an int, and try to find one listing that matches
    listing = @user_listings.find do |listing|
      listing.id == input.to_i
    end
    # in the event that the user hits F, return F so that we can exit the loop later
    if input == "F" || input == "F".downcase
      return "F"
    # otherwise, check and see if the listing existed or was nil
    elsif !listing
      # if there was no matching listing, ask the user to try again
      puts "                 Hey, couldn't find that listing! Please select a valid ID or input 'F'"
      listing_input
    else
      # if there was a matching listing, return it
      return listing
    end
  end

  def arrange_viewing
    spaces(2)
    listing = listing_input
    # keep going until the new input is "F"
    if listing != "F"
      if !@current_user.listing_ids.include?(listing.id)
          Viewing.create(user: @current_user, listing: listing)
          puts "                 Listing #{listing.id} added!"
          system("say 'Listing #{listing.id} added!'")
          puts ""
          puts "                 Add another listing ID or PRESS 'F'"
          #tells User class about the new listings
          @current_user = User.find(@current_user.id)  #refresh User
      else
          puts "                 You've added this listing already!"
          system("say 'You've added this listing already!'")
          puts ""
          puts "                 Please add another listing ID or PRESS 'F'"
      end
      arrange_viewing

    else
      spaces(5)
      ids = @current_user.listing_ids.join ", "
      # system("open '#{@current_user.listings.url}'")
      ids = ids
      # system("say 'Your listings are: #{ids}.'")
      # puts "Your listings are: #{ids}."

      open_listings
      return
    end
  end

  def open_listings
    system("say 'OK #{@name} now I'm going to open the listings for you. Be ready!'")
    system("say 'While you take a look at them I'm going to look at your calendar to arrange the viewings, you don't need to worry about anything else.'")
    @current_user.listings.each do |ls|
      # binding.pry
      # url = ls.url
      system("open '#{ls.url}'")
    end
  end


end  #ends class

cli = CLI.new

cli.start_cli










# ruby ./bin/run.rb
