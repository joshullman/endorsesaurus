class RecommendationController < ApplicationController
	before_action :find_recommendations, only: [:show, :edit, :update, :destroy]
	
  def index
    @recommendations = Recommendation.all
  end

  def show
  end

  def new
    @recommendation = Recommendation.new
  end

  def edit
  end

  def create
    @recommendation = Recommendation.new(params[:recommendation])

    if @recommendation.save
      redirect_to @recommendation, notice: 'Recommendation was successfully created.'
    else
      render action: "new"
    end
  end

  def update

    if @recommendation.update_attributes(params[:recommendation])
      redirect_to @recommendation, notice: 'Recommendation was successfully updated.'
    else
      render action: "edit"
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
		params.require(:recommendation).permit(:sender_id, :receiver_id, :media_id, :liked)
	end

end
