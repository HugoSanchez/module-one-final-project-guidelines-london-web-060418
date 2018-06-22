class First < ActiveRecord::Migration[5.0]

  def change
    create_table :listings do |t|
      t.string :address
      t.string :postcode
      t.integer :num_bedrooms
      t.integer :num_bathrooms
      t.integer :price
      t.text :short_description
      t.string :url
    end
  end

end
