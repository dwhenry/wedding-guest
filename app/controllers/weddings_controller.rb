class WeddingsController < ApplicationController
  layout 'sidebar'
  def index
    @weddings = current_user.weddings.where("guests.status = 'Confirmed'")

    respond_to do |format|
      format.html { render :index, :layout => 'full_width' }
      format.json { render :json => @weddings.map{|w| w.details.merge('url' => wedding_path(w)) } }
    end
  end

  def new
    @wedding = Wedding.new
    render :new, :layout => 'full_width'
  end

  def create
    @wedding = Wedding.new(params[:wedding])
    begin
      @wedding.save!
      redirect_to wedding_path(@wedding)
    rescue => e
      render :new, :layout => 'full_width'
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
      render :edit
    end
  end

  def show
    respond_to do |format|
      format.html { @wedding = Wedding.find(params[:id]) }
      format.json { render :json => Wedding.find(params[:id]).details(current_user) }
    end
  end

  def delete_all
    Wedding.delete_all if params[:key] = 'defo'
    Wedding.delete_all({:name => nil}) if params[:key] = 'blank'
  end

  def rotate_image
    wedding = Wedding.find(params[:id])
    wedding.image.rotate!(params[:angle].to_i)
    wedding.image.thumb.cache!(wedding.image.file)
    wedding.image.thumb.store!
    wedding.save
    redirect_to wedding
  end

private
  def wedding
    Wedding.find_by_id(params[:id])
  end
end
