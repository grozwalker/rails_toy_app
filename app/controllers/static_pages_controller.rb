# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    return unless  logged_in?

    @micropost = current_user.microposts.new
    @feed = current_user.feed.paginate page: params[:page], per_page: 2
  end

  def help; end

  def about; end

  def contact; end
end
