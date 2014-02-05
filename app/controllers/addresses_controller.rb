class AddressesController < ApplicationController
  def index
    @wedding = Wedding.find(params[:wedding_id])
    @rsvps = Rsvp.where(wedding_id: params[:wedding_id])
  end
end