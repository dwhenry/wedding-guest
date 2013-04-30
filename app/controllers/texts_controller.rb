class TextsController < ApplicationController
  # GET /texts
  # GET /texts.json
  def index
    @wedding = Wedding.find(params[:wedding_id])
    @texts = @wedding.texts

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @texts }
    end
  end

  # GET /texts/new
  # GET /texts/new.json
  def new
    @wedding = Wedding.find(params[:wedding_id])
    @text = Text.new(:wedding_id => @wedding.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @text }
    end
  end

  # GET /texts/1/edit
  def edit
    @wedding = Wedding.find(params[:wedding_id])
    @text = Text.find(params[:id])
  end

  # POST /texts
  # POST /texts.json
  def create
    @wedding = Wedding.find(params[:wedding_id])
    @text = Text.new(params[:text])

    respond_to do |format|
      if @text.save
        format.html { redirect_to wedding_texts_path(@wedding), notice: 'Text was successfully created.' }
        format.json { render json: @text, status: :created, location: @text }
      else
        format.html { render action: "new" }
        format.json { render json: @text.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /texts/1
  # PUT /texts/1.json
  def update
    @wedding = Wedding.find(params[:wedding_id])
    @text = Text.find(params[:id])

    respond_to do |format|
      if @text.update_attributes(params[:text])
        format.html { redirect_to wedding_texts_path(@wedding), notice: 'Text was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @text.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /texts/1
  # DELETE /texts/1.json
  def destroy
    @wedding = Wedding.find(params[:wedding_id])
    @text = Text.find(params[:id])
    @text.destroy

    respond_to do |format|
      format.html { redirect_to wedding_texts_url(@wedding) }
      format.json { head :no_content }
    end
  end
end
