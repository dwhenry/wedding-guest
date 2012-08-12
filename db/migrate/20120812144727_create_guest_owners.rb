class CreateGuestOwners < ActiveRecord::Migration
  def change
    create_table :guest_owners do |t|
      t.string :name
      t.references :wedding

      t.timestamps
    end
    add_index :guest_owners, :wedding_id
  end
end
