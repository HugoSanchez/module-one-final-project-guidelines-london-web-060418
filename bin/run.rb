require_relative '../config/environment'

class CLI

  @@hoods = ["Hampstead", "Chelsea", "Clapham", "Victoria", "Shoreditch", "Canary Wharf", "Soho", "Camden", "Islington", "Fulham"]

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
    spaces(30)
    @name = gets.chomp.capitalize
    spaces(30)
    puts "            Hi #{@name}, welcome to London Property Listings, we are here to help you

                                     find your perfect new home!"
    @current_user = User.create(name: @name)

  end

    def yes_no
      puts "               We are going to ask you a few questions to help us find you the right place."
      puts ""
      puts "                                        Shall we go ahead, #{@name}?"
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
        spaces(5)
        select_area(@@hoods)
        # spaces(10)
        # choose_area
      elsif choice == "n"
        spaces(15)
        puts "            Hope to see you again soon, #{@name}!"
      else
        puts "            Ooops...please type Y or N"
        choice = gets.chomp
        options(choice)
      end
  end

  def select_area(array)
    array.each_with_index do |neighborhood, i|
      puts "                              #{i+1} - #{neighborhood}"
      puts ""
    end
    spaces(10)
    choose_area
  end

  def choose_area
    puts "            Enter area number:"
    @area_choice = gets.chomp.to_i
    @area_choice = @@hoods[@area_choice -1]
    spaces(30)
    puts "                 #{@area_choice} - great choice!"
    puts ""
    puts ""
    puts ""
    puts "                 Here's some information about this neighborhood:"
    puts ""
    puts ""
    display_the_hood
  end

  def display_the_hood
    hood_choice = Neighborhood.find_by name: @area_choice
    puts "                 It has #{hood_choice.restaurants.downcase} restaurants."
    puts ""
    puts "                 It has #{hood_choice.parks.downcase} parks."
    puts ""
    puts "                 Regarding public transport, #{@area_choice} is #{hood_choice.public_transport.downcase}."
    puts ""
    puts "                 It has #{hood_choice.public_schools} public school(s)."
    puts ""
    puts "                 The residents average age here is #{hood_choice.average_age}."
    puts ""
    puts "                 Crime rate is #{hood_choice.crime_rate}, on a scale of 1-10 (low-high)."
    puts ""
    spaces(10)
    continue_to_bedrooms   #PRESS C to continue
  end

  def continue_to_bedrooms
    puts "PRESS C to continue"
    c = gets.chomp
    spaces(30)
    if c.downcase == "c"
      bedrooms
      spaces(30)
    else
      continue_to_bedrooms
    end
  end

  def bedrooms
    puts "                 How many bedrooms would you like?"
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
    spaces(5)
    puts "                 Enter a number between 1 and 5:"
    spaces(20)
    @num_bath = gets.chomp.to_i
    spaces(30)
    if @num_bath > 0 && @num_bath < 6
      puts "                 Great! You chose #{@num_bed} bedrooms and #{@num_bath} bathrooms."
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
    puts ""
    puts "                         What is your budget?"
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
    @user_listings = Listing.where(:neighborhood => @area_choice)
    @user_listings = @user_listings.select {|l| l.num_bedrooms == @num_bed}
    # @user_listings = @user_listings.select {|l| l.num_bathrooms == @num_bath}
    # @user_listings = @user_listings.select {|l| l.price < @user_budget}

    if @user_listings.length == 0
      puts "                 Sorry! We have no listings mathcing your criteria. Please try again!"
      yes_no
    else
      puts "                 Awesome! We have #{@user_listings.length} listings for you:"
      spaces(2)

      @user_listings.each do |listing|
        puts "                 Lisiting ID:   #{listing.id}"
        puts "                 *****************************"
        puts "                 Address: #{listing.address}"
        # puts listing.postcode
        puts "                 Property type: #{listing.property_type}"
        puts "                 Bedrooms: #{listing.num_bedrooms}"
        puts "                 Bathrooms: #{listing.num_bathrooms}"
        puts "                 Price: £#{listing.price}"
        spaces(2)
      end
      continue_to_viewings
    end
  end

  def continue_to_viewings
    puts "PRESS V to arrange VIEWINGS:"
    c = gets.chomp
    spaces(40)
    if c.downcase == "v"
      arrange_viewing
      spaces(30)
    else
      continue_to_viewings
    end
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
    puts "                 To arrange a viewing with us please ENTER the listing ID
                                and we will take care of it!"
    puts ""
    puts "                            You can add as many as you like."
    puts ""
    puts "                 Once you've finished, PRESS 'F' to see your selection."
    spaces(2)
    listing = listing_input
    viewing_ids = []
    # keep going until the new input is "F"
    while listing != "F" #|| check if the user already has that lisitng

      # def val_users
      # Viewing.all.select do |user|
      #   binding.pry
      #   user.id == @current_user.id
      #     puts "found user #{@current_user.id }"
      #   end
      # end

      def users_viewings
      Viewing.all.select do |viewing|
        viewing.user_id == @current_user.id
        end
      end

      #all user's listings:
      # def listings
      #   users_viewings.map do |viewing|
      #     viewing.listing
      #   end
      # end

      #all user's listings ids:
      def listings
        users_viewings.map do |viewing|
          viewing.listing_id
        end
      end

      # Viewing.all[i].listing_id == some_id_you_want_to_add
      #
      # Viewing.all.each do ||
      # if
      new_viewing = Viewing.create(user: @current_user, listing: listing)

      viewing_ids << listing.id
      puts "                 Listing #{listing.id} added!"
      puts ""
      puts "                 Add another listing ID or PRESS 'F'"
      # ask the user for input again
      listing = listing_input
    end
    # puts "                 You hit 'F'. Love you!"
    spaces(5)
    ids = viewing_ids.join ", "
    ids = ids.uniq
    puts "You selected: #{ids}."

  end


end  #ends class

cli = CLI.new

cli.start_cli










# ruby ./bin/run.rb
