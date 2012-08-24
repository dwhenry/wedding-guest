class RenameGuestOwnerToGuestList < ActiveRecord::Migration
  def up
    rename_table :guest_owners, :guest_lists
    rename_column :guests, :guest_owner_id, :guest_list_id
  end

  def down
    rename_table :guest_lists, :guest_owners
    rename_column :guests, :guest_list_id, :guest_owner_id
  end
end
