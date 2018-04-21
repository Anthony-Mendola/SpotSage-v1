class CreateParkings < ActiveRecord::Migration[5.1]
  def change
    create_table :parkings do |t|
      t.string :space_type
      t.string :area
      t.integer :square_footage
      t.integer :spaces
      t.string :accessibility
      t.string :listing_name
      t.text :summary
      t.string :address
      t.boolean :is_electric
      t.boolean :is_water
      t.boolean :is_heating
      t.integer :price
      t.boolean :active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
