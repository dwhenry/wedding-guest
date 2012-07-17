class WeddingsController < ApplicationController

  def index
    @weddings = Wedding.all
  end

  def new
    @wedding = Wedding.new
  end

  def create
    @wedding = Wedding.new(params[:wedding])
    begin
      @wedding.save!
      redirect_to wedding_path(@wedding)
    rescue => e
      debugger
      render :new
    end
  end

  def show
    @wedding = Wedding.find(params[:id])
  end
end
