class GuestsController < ApplicationController
  def index
    @wedding = Wedding.find(params[:wedding_id])
  end
end