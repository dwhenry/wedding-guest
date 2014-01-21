class RsvpsController < ApplicationController
  def create
    @rsvp = Rsvp.new(params[:rsvp])
    @wedding = @rsvp.wedding

    @rsvp.valid?
    if verify_recaptcha(model: @rsvp) && @rsvp.save
      redirect_to rsvp_external_path(@wedding.param_name)
    else
      render 'external/rsvp'
    end
  end

protected

  def authenticate_user!
    true
  end
end