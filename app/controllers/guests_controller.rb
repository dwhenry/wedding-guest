class GuestsController < ApplicationController
  def index
    @wedding = Wedding.find(params[:wedding_id])
  end

  def create
    guest = Guest.create(params[:guest].merge(:wedding_id => params[:wedding_id]))
    render :json => {:id => guest.id, :errors => guest.errors}
  end
end