class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.references :wedding
      t.string :name
      t.string :code
      t.string :link
      t.float :price

      t.timestamps
    end
    add_index :gifts, :wedding_id
  end
end
