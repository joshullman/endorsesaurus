# recommendations should be simple - they either exist or they dont.  The user controller
# handles the logic behind displaying the recommendation.  All that needs to be done here
# is handling the creation of recommendations and maybe the logic behind de-recommending
# if you decide you don't want to include your recommendation.  Either way, the logic
# will be handled on the profile.


class RecommendationsController < ApplicationController

  def create
    sender = params[:sender]
    receiver = params[:receiver]
    medium_id = params[:medium_id]
    medium = Medium.find(medium_id)
    media_type = medium.media_type

    Recommendation.create(sender_id: sender, receiver_id: receiver, medium_id: medium_id)

    medium.recommended_count = medium.recommended_count + 1
    medium.save

    case media_type
      when "Movie"
        redirect_to movies_user_path(receiver)
      when "Season"
        redirect_to shows_user_path(receiver)
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
        redirect_to movies_user_path(receiver)
      when "Season"
        redirect_to shows_user_path(receiver)
    end
  end

	private

	def recommendation_params
		params.require(:recommendation).permit(:sender_id, :receiver_id, :medium_id)
	end

end
