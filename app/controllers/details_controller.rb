class DetailsController < ApplicationController
  # GET /details
  # GET /details.json
  def index
    @wedding = Wedding.find(params[:wedding_id])
    @details = Detail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @details }
    end
  end

  # GET /details/new
  # GET /details/new.json
  def new
    @wedding = Wedding.find(params[:wedding_id])
    @detail = Detail.new(:wedding_id => @wedding.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @detail }
    end
  end

  # GET /details/1/edit
  def edit
    @wedding = Wedding.find(params[:wedding_id])
    @detail = Detail.find(params[:id])
  end

  # POST /details
  # POST /details.json
  def create
    @wedding = Wedding.find(params[:wedding_id])
    @detail = Detail.new(params[:detail])

    respond_to do |format|
      if @detail.save
        format.html { redirect_to wedding_details_path(@wedding), notice: 'Detail was successfully created.' }
        format.json { render json: @detail, status: :created, location: @detail }
      else
        format.html { render action: "new" }
        format.json { render json: @detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /details/1
  # PUT /details/1.json
  def update
    @wedding = Wedding.find(params[:wedding_id])
    @detail = Detail.find(params[:id])

    respond_to do |format|
      if @detail.update_attributes(params[:detail])
        format.html { redirect_to wedding_details_path(@wedding), notice: 'Detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /details/1
  # DELETE /details/1.json
  def destroy
    @wedding = Wedding.find(params[:wedding_id])
    @detail = Detail.find(params[:id])
    @detail.destroy

    respond_to do |format|
      format.html { redirect_to wedding_details_url(@wedding) }
      format.json { head :no_content }
    end
  end
end
