class ModifyWedingFieldToUserCarrierwave < ActiveRecord::Migration
  def up
    remove_column :weddings, :image
    add_column :weddings, :image, :string
  end

  def down
    remove_column :weddings, :image
    add_column :weddings, :image, :binary
  end
end
