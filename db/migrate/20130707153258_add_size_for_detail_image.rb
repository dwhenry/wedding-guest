class AddSizeForDetailImage < ActiveRecord::Migration
  def up
    add_column :details, :image_size, :string
    execute "update details set image_size = 'small'"
  end

  def down
    remove_column :details, :image_size
  end
end
