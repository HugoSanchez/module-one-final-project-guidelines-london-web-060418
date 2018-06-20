class Neigh < ActiveRecord::Migration[5.0]

  def change
    create_table :neighborhoods do |t|
      t.string :name
      t.integer :public_schools
      t.integer :crime_rate
      t.string :restaurants
      t.string :parks
      t.string :public_transport
      t.string :average_age
    end
  end
end
