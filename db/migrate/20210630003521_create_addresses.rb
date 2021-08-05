# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.integer :number
      t.string :zip_code
      t.string :neighborhood
      t.string :city
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end
