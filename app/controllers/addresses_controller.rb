class AddressesController < ApplicationController
  def index
    @wedding = Wedding.find(params[:wedding_id])
    @addresses = @wedding.addresses
    @address = Address.new(:wedding => @wedding)
  end

  def create
    address = Address.new(params[:address])
    address.save!
    render :partials => 'show', :locals => {:address => address}
  rescue ActiveRecord::RecordInvalid
    render :text => address.errors.to_hash, :status => 409
  end

  def destroy
    Address.find(params[:id]).delete!
  end
end