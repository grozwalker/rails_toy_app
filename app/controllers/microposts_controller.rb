# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :user_logged_in, only: %i[create destroy]
  before_action :correct_user, only: %i[destroy]

  # rubocop:todo Metrics/AbcSize
  def create
    @micropost = current_user.microposts.new micropost_params
    @micropost.image.attach params[:micropost][:image]

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

  def destroy
    @micropost.destroy!

    flash[:success] = 'Successfully destroyed'

    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])

    return unless @micropost.nil?

    flash[:error] = 'Cant delete micropost'
    redirect_to root_url
  end
end
