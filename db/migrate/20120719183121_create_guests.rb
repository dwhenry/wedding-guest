class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :status
      t.references :wedding

      t.timestamps
    end
    add_index :guests, :wedding_id
  end
end
