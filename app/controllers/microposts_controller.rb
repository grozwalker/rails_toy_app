# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :user_logged_in, only: %i[create destroy]

  # rubocop:todo Metrics/AbcSize
  def create
    @micropost = current_user.microposts.new micropost_params

    if @micropost.save
      flash[:success] = 'Successfully create micropost'

      redirect_to root_url
    else
      flash[:error] = 'Cant create micropost'
      @feed = current_user.feed.paginate page: params[:page]

      render 'static_pages/home'
    end
  end
  # rubocop:enable Metrics/AbcSize

  def destroy; end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
