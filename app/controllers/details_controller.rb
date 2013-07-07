class DetailsController < ApplicationController
  before_filter :can_edit

private

  def can_edit
    wedding.owner?(current_user)
  end

public

  def sort
    wedding = Wedding.find(params[:wedding_id])
    detail = Detail.find(params[:id])

    render json: { success: detail.move_to(params[:position].to_i) }
  end

  # GET /texts
  # GET /texts.json
  def index
    @wedding = Wedding.find(params[:wedding_id])
    @details = @wedding.page_details

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @texts }
    end
  end

  # GET /texts/new
  # GET /texts/new.json
  def new
    @wedding = Wedding.find(params[:wedding_id])
    @detail = Detail.new(:wedding_id => @wedding.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @text }
    end
  end

  # GET /texts/1/edit
  def edit
    @wedding = Wedding.find(params[:wedding_id])
    @detail = Detail.find(params[:id])
  end

  # POST /texts
  # POST /texts.json
  def create
    @wedding = Wedding.find(params[:wedding_id])
    @detail = Detail.new(params[:detail])

    respond_to do |format|
      if @detail.save
        expire_external_cache
        format.html { redirect_to wedding_details_path(@wedding), notice: 'Detail was successfully created.' }
        format.json { render json: @detail, status: :created, location: @detail }
      else
        format.html { render action: "new" }
        format.json { render json: @detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /texts/1
  # PUT /texts/1.json
  def update
    @wedding = Wedding.find(params[:wedding_id])
    @detail = Detail.find(params[:id])

    respond_to do |format|
      if @detail.update_attributes(params[:detail])
        expire_external_cache
        format.html { redirect_to wedding_details_path(@wedding), notice: 'Detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /texts/1
  # DELETE /texts/1.json
  def destroy
    @wedding = Wedding.find(params[:wedding_id])
    @detail = Detail.find(params[:id])
    @detail.destroy

    respond_to do |format|
      format.html { redirect_to wedding_details_url(@wedding) }
      format.json { head :no_content }
    end
  end

private

  def expire_external_cache
    url = external_url(
      wedding_name: @wedding.param_name,
      name: @detail.raw_page_name
    ).split(%r{://}).last # This is a hack copied from actionpack to make it all work
    ActionController::Base.cache_store.delete(fragment_cache_key(url))
  end
end
