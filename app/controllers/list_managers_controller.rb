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
    guest_list.user = params[:data][:user]
    render :json => details_for(guest_list)
  end

  # this should be a delete owner route...
  # however as this is implemented using buttons at this stage it is
  # a get...
  # This is wrong and incorrect and everything..
  # TODO: make this a get before it is released for general use..
  def owner
    guest_list = GuestList.find(params[:id])
    guest_list.remove_user_permissions(params[:user_id])
    redirect_to wedding_list_managers_path(guest_list.wedding)
  end

private

  def details_for(guest_list)
    {
      :id => guest_list.id,
      :url => (guest_list.id ? wedding_list_manager_path(guest_list.wedding, guest_list) : ''),
      :errors => guest_list.errors.full_messages.join("\n"),
      guest_list.id => guest_list.attributes.merge(:user => user_list_for(guest_list))
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