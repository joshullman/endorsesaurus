# recommendations should be simple - they either exist or they dont.  The user controller
# handles the logic behind displaying the recommendation.  All that needs to be done here
# is handling the creation of recommendations and maybe the logic behind de-recommending
# if you decide you don't want to include your recommendation.  Either way, the logic
# will be handled on the profile.


class RecommendationsController < ApplicationController
	before_action :find_recommendations, only: [:show, :edit, :update, :destroy]

  def new
    @recommendation = Recommendation.new
  end

  def create
    # if recommendation exists, ignore
    # else, make recommendation

    @recommendation = Recommendation.new(params[:recommendation])

    if @recommendation.save
      redirect_to @recommendation, notice: 'Recommendation was successfully created.'
    else
      render action: "new"
    end
  end

  def destroy
    @recommendation.destroy

    redirect_to recommendations_url
  end

	private

	def find_recommendations
		@recommendation = Recommendation.find(session[:recommendation_id])
	end

	def recommendation_params
		params.require(:recommendation).permit(:sender_id, :receiver_id, :media_id)
	end

end
