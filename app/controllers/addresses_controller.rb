class AddressesController < ApplicationController
  def index
    @wedding = Wedding.find(params[:wedding_id])
    @rsvps = Rsvp.where(wedding_id: params[:wedding_id], evening: false).order(:id)
    @rsvp_evenings = Rsvp.where(wedding_id: params[:wedding_id], evening: true).order(:id)
  end
end