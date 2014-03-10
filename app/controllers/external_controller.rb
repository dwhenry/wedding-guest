class ExternalController < ApplicationController
  caches_action :show,
    cache_path: ->(controller) do
      if params[:name].nil?
        external_url(params.slice(:wedding_name).merge(name: 'home', for: Date.today))
      else
        external_url(params.slice(:wedding_name, :name).merge(for: Date.today))
      end
    end

  def show
    @wedding = Wedding.find_by_param_name(params[:wedding_name])
    if @wedding.nil?
      redirect_to new_user_session_path
    else
      @name = params[:name] || 'home'
    end
  end

  def rsvp
    @wedding = Wedding.find_by_param_name(params[:wedding_name])
    @rsvp = Rsvp.new(wedding: @wedding)
  end

  def rsvp_evening
    @wedding = Wedding.find_by_param_name(params[:wedding_name])
    @rsvp = Rsvp.new(wedding: @wedding, evening: true)
  end

  def index
    render :index
  end

protected

  def authenticate_user!
    true
  end
end