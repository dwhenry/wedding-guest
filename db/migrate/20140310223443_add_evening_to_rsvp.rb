class AddEveningToRsvp < ActiveRecord::Migration
  def change
    add_column :rsvps, :evening, :boolean, default: false
  end
end
