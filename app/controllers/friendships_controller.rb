class FriendshipsController < ApplicationController
	def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id], accepted: "false")
    if @friendship.save
      flash[:notice] = "Friend requested."
      redirect_to :back
    else
      flash[:error] = "Unable to request friendship."
      redirect_to :back
    end
  end

  # PATCH/PUT /friendships/1
  # PATCH/PUT /friendships/1.json
  def update
  @friendship = Friendship.where(friend_id: current_user, user_id: params[:id]).first
  @friendship.update(accepted: true)
    if @friendship.save
      redirect_to :back, :notice => "Successfully confirmed friend!"
      Notification.create(user_one_id: @friendship.user_id, user_two_id: @friendship.friend_id, notification_type: "friends")
    else
      redirect_to :back, :notice => "Sorry! Could not confirm friend!"
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship = Friendship.where(friend_id: [current_user, params[:id]]).where(user_id: [current_user, params[:id]]).last
    @friendship.destroy
    flash[:notice] = "Removed friendship."
    redirect_to :back
  end
end
