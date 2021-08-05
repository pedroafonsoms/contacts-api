# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :telephone
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
