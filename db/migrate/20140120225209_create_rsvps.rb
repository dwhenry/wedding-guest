class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.references :wedding
      t.string :name
      t.string :email
      t.boolean :attendance
      t.string :dietary
      t.string :message
      t.references :linked

      t.timestamps
    end

    add_index :rsvps, :wedding_id
    add_index :rsvps, :linked_id
  end
end
