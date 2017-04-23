class Micropost < ActiveRecord::Base
  belongs_to :user

  # @note ORMのレコードを呼ぶ出す時、デフォルトで設定したい場合に使う
  default_scope -> {order('created_at DESC')}

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
