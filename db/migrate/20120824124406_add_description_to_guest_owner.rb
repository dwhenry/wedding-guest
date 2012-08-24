class AddDescriptionToGuestOwner < ActiveRecord::Migration
  def change
    add_column :guest_owners, :description, :string
    {
      'All' => 'All Guests for the wedding',
      'Bride' => "The Bride''s guests to the wedding",
      'Groom' => "The Groom''s guests to the wedding"
    }.each do |name, description|
      execute "update guest_owners set description = '#{description}' where name = '#{name}'"
    end
  end
end
