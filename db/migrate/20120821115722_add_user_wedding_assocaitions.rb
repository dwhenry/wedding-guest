class AddUserWeddingAssocaitions < ActiveRecord::Migration
  def up
    add_column :weddings, :groom_email, :string
    add_column :weddings, :bride_email, :string

    remove_column :guests, :owner

    create_table :guest_permissions do |t|
      t.references :user
      t.references :guest
      t.references :list

      t.timestamps
    end
  end

  def down
    drop_table :guest_permissions

    add_column :guests, :owner, :string

    remove_column :weddings, :groom_email
    remove_column :weddings, :bride_email
  end
end
