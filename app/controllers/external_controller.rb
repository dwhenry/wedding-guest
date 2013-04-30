class ExternalController < ApplicationController
  def authenticate_user!
    true
  end

  def show
    @wedding = Wedding.find_by_param_name(params[:wedding_name])
    if @wedding.nil?
      redirect_to new_user_session_path
    end
  end

  def home
    @wedding = Wedding.find_by_param_name(params[:wedding_name])
    @home = @wedding.text(Text::HOME)
  end

  def about_us
    @wedding = Wedding.find_by_param_name(params[:wedding_name])

    @groom = @wedding.groom.titlecase
    @about_him = @wedding.text(Text::ABOUT_GROOM)

    @bride = @wedding.bride.titlecase
    @about_her = @wedding.text(Text::ABOUT_BRIDE)

    @how_we_met = @wedding.text(Text::HOW_WE_MET)
    @proposal = @wedding.text(Text::PROPOSAL)
  end
end