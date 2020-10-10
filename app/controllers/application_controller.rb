# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentification

  helper_method :logged_in?, :current_user
end
