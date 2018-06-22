class CreateUserAndViewingTables < ActiveRecord::Migration[5.0]

  def change
    create_table :users do |t|
      t.string :name
      t.string :password
    end

    create_table :viewings do |t|
      t.integer :user_id
      t.integer :listing_id
    end
  end

end
