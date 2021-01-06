# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :user_logged_in, only: %i[create destroy]

  def create
    @micropost = current_user.microposts.new micropost_params

    if @micrpoost.save
      flash[:success] = 'Successfully create micropost'

      redirect_to root_url
    else
      flash[:error] = 'Cant create micropost'

      render 'static_page/home'
    end
  end

  def destroy; end
end
