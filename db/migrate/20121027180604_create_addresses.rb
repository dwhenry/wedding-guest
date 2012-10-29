class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :wedding
      t.string :address_type
      t.string :name
      t.string :line_1
      t.string :line_2
      t.string :post_code
      t.string :map_ref

      t.timestamps
    end
    add_index :addresses, :wedding_id
  end
end
