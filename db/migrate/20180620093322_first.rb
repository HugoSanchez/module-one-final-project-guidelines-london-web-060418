class First < ActiveRecord::Migration[5.0]

  def change
    create_table :listings do |t|
      t.string :address
      t.string :outcode
      t.string :listing_status
      t.string :property_type
      t.integer :num_bedrooms
      t.integer :num_bathrooms
      t.integer :price
      t.text :short_description
      t.datetime :listing_date
    end
  end

end
