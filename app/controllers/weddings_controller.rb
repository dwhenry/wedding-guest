class WeddingsController < ApplicationController

  def index
    @weddings = Wedding.all

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @weddings.map(&:details) }
    end
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

  def edit
    @wedding = Wedding.find(params[:id])
  end

  def update
    @wedding = Wedding.find(params[:id])

    begin
      @wedding.update_attributes!(params[:wedding])
      redirect_to wedding_path(@wedding)
    rescue => e
      debugger
      render :edit
    end
  end

  def show
    @wedding = Wedding.find(params[:id])
  end

  def delete_all
    Wedding.delete_all if params[:key] = 'defo'
  end

  def rotate_image
    wedding = Wedding.find(params[:id])
    wedding.image.rotate!(params[:angle].to_i)
    wedding.save
    redirect_to wedding
  end
end
