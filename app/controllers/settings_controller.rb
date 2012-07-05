class SettingsController < ApplicationController
  def index
  end

  def create
    session[:flow_data_url] = params[:flow_data_url]
    redirect_to settings_url
  end
end
