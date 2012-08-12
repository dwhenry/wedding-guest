class ModifyGuestsTable < ActiveRecord::Migration
  def up
    add_column :guests, :seats, :integer
    add_column :guests, :owner, :string
    add_column :guests, :guest_owner_id, :integer
    Guest.delete_all
    Wedding.delete_all
  end

  def down
    remove_column :guests, :seats
    remove_column :guests, :owner
    remove_column :guests, :guest_owner_id
  end
end
