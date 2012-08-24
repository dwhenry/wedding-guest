class GuestsController < ApplicationController
  def index
    @wedding = Wedding.find(params[:wedding_id])
  end

  def create
    guest = Guest.create(params[:guest].merge(params.slice(:wedding_id)))
    render :json => details_for(guest)
  end

  def update
    guest = Guest.find(params[:id])
    guest.update_attributes(params[:guest])
    render :json => details_for(guest)
  end

  private

  def details_for(guest)
    {
      :id => guest.id,
      :url => (guest.id ? wedding_guest_path(guest.wedding, guest) : ''),
      :errors => guest.errors.full_messages.join("\n"),
      guest.id => guest.attributes.merge(:contact => guest.contact)
    }
  end
end