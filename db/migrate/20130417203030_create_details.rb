class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.references :wedding
      t.string :detail_type
      t.text :detail_text
      t.string :image

      t.timestamps
    end
  end
end
