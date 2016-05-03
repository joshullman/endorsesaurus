class Rec
	attr_reader :rec_array, :user_points, :media_points, :rec_by, :info
	def initialize(rec_array = [])
		@rec_array = rec_array
		@info = Medium.find(rec_array.first.media_id)
		@media_points = 0
		@user_points = 0
		@rec_by = []
	end

	def push_reccommenders
		@rec_array.each {|rec| @rec_by << User.find(rec.sender)}
	end

	def determine_user_points
		@rec_by.each {|user| @user_points += user.points}
	end

	def rec_by_user?(user_id)
		@rec_by.any? {|rec| rec.id == user_id}
	end

	def do_all_the_stuff
		push_reccommenders
		determine_user_points
	end

end

class UserController < ApplicationController

  def show
  	# Profile information
  	@user = User.find(params[:id])
  	recommendations = Recommendation.where(receiver: @user.id).group_by(&:media_id)
  	likes = Like.where(user_id: @user.id).group_by(&:value)

  	@recs = []
  	recommendations.each_value do |array|
  		rec = Rec.new(array)
  		rec.do_all_the_stuff
  		@recs << rec
  	end
  	@recs.sort_by! {|rec| rec.user_points}.reverse!

  	# finding the media assosciated with Likes
  	@likes = {}
  	def organize_likes(likes, instance_likes)
	  	likes.each_key do |key|
	  		instance_likes[key] = []
	  		likes[key].each do |like|
	  			instance_likes[key] << Medium.find(like.media_id)
	  		end
	  	end
  	end
  	organize_likes(likes, @likes)

  	# finding recently watched
  	recents = Like.where(user_id: @user.id).last(5).reverse
  	@recently_watched = {}
  	recents.each do |like|
  		@recently_watched[Medium.find(like.media_id)] = like.value
  	end

  	p @likes

  	#current_user information

  	# current_user_likes = Like.where(user_id: current_user.id).group_by(&:value)
  	# @current_user_likes = {}
  	# organize_likes(current_user_likes, @current_user_likes)
  end

end
