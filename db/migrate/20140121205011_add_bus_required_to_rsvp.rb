class AddBusRequiredToRsvp < ActiveRecord::Migration
  def change
    add_column :rsvps, :bus_required, :boolean
  end
end
