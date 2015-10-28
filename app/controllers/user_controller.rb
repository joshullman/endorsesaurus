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

	# def determine_media_points
		# if rec.type == "series"
		# 	series = {"Response" => "True"}
		# 	season = 1
		# 	while series["Response"] == "True"
		# 		url = URI.parse("http://www.omdbapi.com/\?t\=#{api["Title"]}\&Season\=#{season}")
		# 		req = Net::HTTP::Get.new(url.to_s)
		# 		res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
		# 		series = JSON.parse(res.body)
		# 		break if series["Response"] != "True"
		# 		media_points += series["Episodes"].length
		# 		season += 1
		# 	end
		# 	runtime = api["Runtime"].gsub(" min", "").to_i
		# 	media_points = media_points * (runtime.to_f/30).ceil
		# else
		# 	runtime = api["Runtime"].gsub(" min", "").to_i
		# 	media_points = (runtime.to_f/30).ceil
		# end
	# end

	def do_all_the_stuff
		push_reccommenders
		determine_user_points
		# determine_media_points
	end

end

class UserController < ApplicationController

  def show
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
  	likes.each_key do |key|
  		@likes[key] = []
  		likes[key].each do |like|
  			@likes[key] << Medium.find(like.media_id)
  		end
  	end

  	# finding recently watched
  	recents = Like.where(user_id: @user.id).last(5).reverse
  	@recently_watched = {}
  	recents.each do |like|
  		@recently_watched[Medium.find(like.media_id)] = like.value
  	end

  	p @likes
  end

end
