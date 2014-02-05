class AddressesController < ApplicationController
  def index
    @wedding = Wedding.find(params[:wedding_id])
    @rsvps = Rsvp.wheer(wedding_id: params[:wedding_id])
  end
end