class RethingDetails < ActiveRecord::Migration
  def up
    rename_table :texts, :details

    add_column :details, :page_name, :string
    add_column :details, :order, :integer
    add_column :details, :formatting_class, :string

    rename_column :details, :detail_text, :text
    remove_column :details, :detail_type
  end

  def down
    remove_column :details, :page_name
    remove_column :details, :order
    remove_column :details, :formating_class

    rename_column :details, :text, :detail_text
    add_column :details, :detail_type, :string

    rename_table :details, :texts
  end
end
