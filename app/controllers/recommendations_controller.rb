class RecommendationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @medium_id = params[:medium_id]
    @media = Medium.find(@medium_id).find_associated_media
    if @media.medium.media_type == "Show"
      @existing_recommendations = []
      @friends = current_user.friends
      @recommended_to = []
      @already_liked = []
      @already_seen = []
      @already_disliked = []

      @friends.each do |friend|
        @recommended_to << friend if friend.already_recommended_show_to?(current_user, @media.id)
        case friend.watched_all_seasons?(@media.id)
          when [true, 1]
            @already_liked << friend
          when [true, 0]
            @already_seen << friend
          when [true, -1]
            @already_disliked << friend
        end
      end

      @possible_recipients = @friends - @recommended_to
      @possible_recipients = @possible_recipients - @already_liked
      @possible_recipients = @possible_recipients - @already_seen
      @possible_recipients = @possible_recipients - @already_disliked

    else
      @existing_recommendations = Recommendation.where(sender_id: current_user.id, medium_id: @medium_id)
      @friends = current_user.friends
      @recommended_to = []
      @already_liked = []
      @already_seen = []
      @already_disliked = []

      @existing_recommendations.each do |rec|
        @recommended_to << rec.receiver
      end

      @friends.each do |friend|
        opinion = Like.where(user_id: friend.id, medium_id: @medium_id)
        if opinion.first
          case opinion.first.value
            when 1
              @already_liked << friend
            when 0
              @already_seen << friend
            when -1
              @already_disliked << friend
          end
        end
      end

      @possible_recipients = @friends - @recommended_to
      @possible_recipients = @possible_recipients - @already_liked
      @possible_recipients = @possible_recipients - @already_seen
      @possible_recipients = @possible_recipients - @already_disliked
    end
  end

  # def create
  #   medium_id = params[:medium_id]
  #   medium = Medium.find(medium_id)
  #   media_type = medium.media_type
  #   if params[:recipients]

  #     sender = current_user
  #     params[:recipients].each do |recipient|
  #       receiver = User.find(recipient)
  #       if media_type == "Show"
  #         recommend_show(sender, receiver, medium.find_associated_media)
  #       else
  #         Recommendation.create(sender_id: sender.id, receiver_id: receiver.id, media_type: media_type, medium_id: medium_id) if !Recommendation.where(sender_id: sender.id, receiver_id: receiver.id, medium_id: medium_id).first

  #         medium.increment_recommends
  #         medium.find_associated_media.show.medium.increment_recommends if media_type == "Season"
  #         Notification.create(user_one_id: sender.id, user_two_id: receiver.id, media_type: media_type, medium_id: medium_id, notification_type: "recommendation")
  #       end
  #     end

  #     case media_type
  #       when "Movie"
  #         redirect_to movie_path(medium.find_associated_media)
  #       when "Season"
  #         redirect_to show_path(medium.find_associated_media.show)
  #       when "Show"
  #         redirect_to show_path(medium.find_associated_media)
  #     end
  #   else

  #     sender = params[:sender]
  #     receiver = params[:receiver]
  #     if media_type == "Show"
  #       recommend_show(sender, receiver, medium.find_associated_media)
  #     else
  #       Recommendation.create(sender_id: sender, receiver_id: receiver, media_type: media_type, medium_id: medium_id)

  #       medium.increment_recommends
  #       medium.find_associated_media.show.medium.increment_recommends if media_type == "Season"
  #       Notification.create(user_one_id: sender, user_two_id: receiver, media_type: media_type, medium_id: medium_id, notification_type: "recommendation")
  #     end
  #     redirect_to :back
  #   end   
  # end

  def create
    p 'I"M GETTING HERE'
    media = Medium.find(params[:medium_id].to_i).find_associated_media
    recipients = params[:recipients].map {|recipient| recipient.to_i }
    p recipients
    media.recommend_to(recipients, current_user.id)
    recipients.each do |recipient|
      Notification.create(user_one_id: current_user.id, user_two_id: recipient, media_type: media.medium.media_type, medium_id: media.medium_id, notification_type: "recommendation")
    end
    if recipients.length == 1
      redirect_to :back
    else
      case media.medium.media_type
        when "Movie"
          redirect_to movie_path(media)
        when "Show"
          redirect_to show_path(media)
        when "Season"
          redirect_to show_path(media.show)
        when "Episode"
          redirect_to show_path(media.show)
      end
    end
  end

  def destroy
    media = Medium.find(params[:medium_id].to_i).find_associated_media
    recipient = params[:recipients].first.to_i
    media.unrecommend_to(recipient, current_user.id)
    note = Notification.where(user_one_id: current_user.id, user_two_id: recipient, medium_id: params[:medium_id], notification_type: "recommendation").first
    note.destroy if note
    redirect_to :back
  end

	private

  # def recommend_show(sender, receiver, show)
  #   show.seasons.each do |season|  
  #     medium = season.medium
  #     if !Recommendation.where(sender_id: sender.id, receiver_id: receiver.id, media_type: "Season", medium_id: medium.id).first
  #       show.medium.increment_recommends
  #       Recommendation.create(sender_id: sender.id, receiver_id: receiver.id, media_type: "Season", medium_id: medium.id)
  #       medium.increment_recommends
  #       Notification.create(user_one_id: sender.id, user_two_id: receiver.id, media_type: "Season", medium_id: medium.id, notification_type: "recommendation")
  #     end
  #   end
  # end

	def recommendation_params
		params.require(:recommendation).permit(:sender_id, :receiver_id, :medium_id)
	end

end
