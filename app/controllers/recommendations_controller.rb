class RecommendationsController < ApplicationController

  def new
    @medium_id = params[:medium_id]
    @media = Medium.find(@medium_id).find_associated_media
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

  def create
    medium_id = params[:medium_id]
    medium = Medium.find(medium_id)
    media_type = medium.media_type
    if params[:recipients]

      sender = current_user
      params[:recipients].each do |recipient|
        receiver = User.find(recipient)
        Recommendation.create(sender_id: sender.id, receiver_id: receiver.id, medium_id: medium_id) if !Recommendation.where(sender_id: sender.id, receiver_id: receiver.id, medium_id: medium_id).first

        medium.recommended_count = medium.recommended_count + 1
        medium.save
        Notification.create(user_one_id: sender.id, user_two_id: receiver.id, medium_id: medium_id, notification_type: "recommendation")
      end

      case media_type
        when "Movie"
          redirect_to movie_path(medium.find_associated_media)
        when "Season"
          redirect_to show_path(medium.find_associated_media.show)
      end
    else

      sender = params[:sender]
      receiver = params[:receiver]
      Recommendation.create(sender_id: sender, receiver_id: receiver, medium_id: medium_id)

      medium.recommended_count = medium.recommended_count + 1
      medium.save
      Notification.create(user_one_id: sender, user_two_id: receiver, medium_id: medium_id, notification_type: "recommendation")

      case media_type
        when "Movie"
          redirect_to :back
        when "Season"
          redirect_to :back
      end
    end   
  end

  def destroy
    sender = params[:sender]
    receiver = params[:receiver]
    medium_id = params[:medium_id]
    media_type = Medium.find(medium_id).media_type

    Recommendation.where(sender_id: sender, receiver_id: receiver, medium_id: medium_id).first.destroy

    case media_type
      when "Movie"
        redirect_to :back
      when "Season"
        redirect_to :back
    end
  end

	private

  def create_recommendation_notification(user_one, user_two, medium)
    media = medium.find_associated_media
    message = "#{user_one.name} recommended #{media.title} to #{user_two.name}!" if medium.media_type == "Movie"
    message = "#{user_one.name} recommended #{media.title} season #{media.season_num} to #{user_two.name}!" if medium.media_type == "Season"
    Notification.create(user_id: user_one.id, message: message)
    Notification.create(user_id: user_two.id, message: message)
  end

	def recommendation_params
		params.require(:recommendation).permit(:sender_id, :receiver_id, :medium_id)
	end

end
