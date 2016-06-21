class LikesController < ApplicationController
	before_action :find_likes, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def create
    user = User.find(params[:user])
    medium = Medium.find(params[:like])
    value = Integer(params[:value])
    media = medium.find_associated_media
  
    media.watch(current_user, value)
    redirect_to :back
  end

  private

	def find_likes
		@likes = Like.find(session[:like_id])
	end

	def like_params
		params.require(:like).permit(:user_id, :media_id, :value)
	end

end
