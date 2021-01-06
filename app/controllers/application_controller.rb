# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentification

  helper_method :logged_in?, :current_user

  private

  def user_logged_in
    return if logged_in?

    flash[:error] = 'Log in'
    store_location

    redirect_to login_path
  end
end
