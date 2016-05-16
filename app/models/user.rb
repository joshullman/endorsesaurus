class User < ActiveRecord::Base
	has_many :sent_recs, class_name: "Recommendation", source: :user_one, foreign_key: "sender_id"
	has_many :received_recs, class_name: "Recommendation", source: :user_two, foreign_key: "receiver_id"

  has_many :sent_notifications, class_name: "Notification", source: :user_one, foreign_key: "user_one_id"
  has_many :received_notifications, class_name: "Notification", source: :user_two, foreign_key: "user_two_id"

  def notifications
    sent_notifications | received_notifications
  end
	has_many :likes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def has_recommended_to?(id, medium_id)
    Recommendation.where(sender_id: self.id, receiver_id: id, medium_id: medium_id).first == nil ? false : true
  end

  def recent_activity
    Notification.where(user_id: self.id).order(created_at: :desc)
  end

  # FRIENDS

  has_many :friendships
  has_many :passive_friendships, :class_name => "Friendship", :foreign_key => "friend_id"

  has_many :active_friends, -> { where(friendships: { accepted: true}) }, :through => :friendships, :source => :friend
  has_many :passive_friends, -> { where(friendships: { accepted: true}) }, :through => :passive_friendships, :source => :user
  has_many :pending_friends, -> { where(friendships: { accepted: false}) }, :through => :friendships, :source => :friend
  has_many :requested_friendships, -> { where(friendships: { accepted: false}) }, :through => :passive_friendships, :source => :user


  def friends
    active_friends | passive_friends
  end

  # OMNIAUTH

  devise :omniauthable, :omniauth_providers => [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.email = auth.info.email   # assuming the user model has a name
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
