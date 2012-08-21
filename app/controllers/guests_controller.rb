class GuestsController < ApplicationController
  def index
    @wedding = Wedding.find(params[:wedding_id])
  end

  def create
    guest = Guest.create(params[:guest].merge(params.slice(:wedding_id, :owner)))
    render :json => {:id => guest.id,
                     :url => wedding_guest_path(guest.wedding, guest),
                     :errors => guest.errors.full_messages.join('<br>')}
  end

  def update
    guest = Guest.find(params[:id])
    guest.update_attributes(params[:guest])
    render :json => {:id => guest.id,
                     :url => wedding_guest_path(guest.wedding, guest),
                     :errors => guest.errors.full_messages.join('<br>')}
  end
end