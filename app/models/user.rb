class User < ActiveRecord::Base
	has_many :sent_recs, class_name: "Recommendation", source: :user_one, foreign_key: "sender"
	has_many :received_recs, class_name: "Recommendation", source: :user_two, foreign_key: "receiver"

	has_many :likes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
