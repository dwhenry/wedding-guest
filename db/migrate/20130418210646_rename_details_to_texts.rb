class RenameDetailsToTexts < ActiveRecord::Migration
  def up
    rename_table :details, :texts
  end

  def down
    rename_table :texts, :details
  end
end
