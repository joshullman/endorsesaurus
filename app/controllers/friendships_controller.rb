class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  
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
  p params[:id]
  @friendship = Friendship.where(friend_id: current_user, user_id: params[:id]).first || Friendship.where(friend_id: params[:id], user_id: current_user).first
  @friendship.update(accepted: true)
    if @friendship.save
      redirect_to :back, :notice => "Successfully confirmed friend!"
      FriendNote.create(sender_id: @friendship.user_id, receiver_id: @friendship.friend_id)
    else
      redirect_to :back, :notice => "Sorry! Could not confirm friend!"
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    note = FriendNote.where(friend_id: [current_user, params[:id]]).where(user_id: [current_user, params[:id]]).last
    note.destroy
    @friendship = Friendship.where(friend_id: [current_user, params[:id]]).where(user_id: [current_user, params[:id]]).last
    @friendship.destroy
    flash[:notice] = "Removed friendship."
    redirect_to :back
  end
end
