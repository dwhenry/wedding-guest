class CreateWeddings < ActiveRecord::Migration
  def change
    create_table :weddings do |t|
      t.string :bride
      t.string :groom
      t.date :on
      t.binary :image

      t.timestamps
    end
  end
end
