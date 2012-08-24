class ListManagersController < ApplicationController
  def index
    @wedding = Wedding.find(params[:wedding_id])
  end

  def create
    guest_list = GuestList.create(params[:data].merge(params.slice(:wedding_id)))
    render :json => details_for(guest_list)
  end


  def update
    guest_list = GuestList.find(params[:id])
    guest_list.update_attributes(params[:data])
    render :json => details_for(guest_list)
  end

private

  def details_for(guest_list)
    {
      :id => guest_list.id,
      :url => (guest_list.id ? wedding_list_manager_path(guest_list.wedding, guest_list) : ''),
      :errors => guest_list.errors.full_messages.join("\n"),
      guest_list.id => guest_list.attributes.merge(:users => user_list_for(guest_list))
    }
  end


  def user_list_for(guest_list)
    guest_list.users.each_with_object({}) do |user, hash|
      hash[user.nickname] = owner_wedding_list_manager_path(
                                  guest_list.wedding, guest_list.id,
                                  :method => 'delete', :user_id => user.id)
    end
  end
end