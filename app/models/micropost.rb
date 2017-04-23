class Micropost < ActiveRecord::Base
  belongs_to :user

  # @note ORMのレコードを呼ぶ出す時、デフォルトで設定したい場合に使う
  default_scope -> {order('created_at DESC')}

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  def self.from_users_followed_by(user)
    followed_user_ids = user.followed_user_ids
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",user_id: user.id)
  end
end
