class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.references :user, foreign_key: true
      t.references :parking, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :price
      t.integer :total

      t.timestamps
    end
  end
end
