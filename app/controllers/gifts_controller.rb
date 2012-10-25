class GiftsController < ApplicationController
  def index
    wedding = Wedding.find(params[:wedding_id])
    respond_to do |format|
      format.json { render :json => wedding.gifts }
    end
  end
end