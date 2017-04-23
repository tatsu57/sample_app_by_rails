class User < ActiveRecord::Base

  # dependent: :destory はuserが削除されるとそれに紐づくmicropostsも削除される
  has_many :microposts, dependent: :destroy

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  # 本来はfollowedsになってしまうが、意味が曖昧になってしまうため,sourceで名前を指定して
  # followed_usersに変更している。
  # throughはrelationshipsのfollowed_idを経由しているからthroughが必要
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy

  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { self.email = email.downcase}

  #呼び出されているクラス内のメソッドをシンボルで呼び出すことができる
  before_create  :create_remeber_token

  validates :name , presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # :case_sensitiveを付けることで、大文字小文字を無視した一意の判定ができる。
  validates :email,
    presence: true,
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  # railsがセキュアなパスワードを生成するためのメソッド。詳細は以下のURL
  # パスワードの存在検証と確認のバリデーションはhas_secure_passwordがやってくれている。
  # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
  has_secure_password
  validates :password, length: { minimum: 6 }

  # 新しいトークンを発行
  # @return [string]
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  # トークンを暗号化する
  # @param [string] トークン
  # @return [string]
  def User.encrypt(token)
    # tokenがnilの場合のto_sをすることで""空文字に変換することで、エラーを回避(テストのため)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    self.relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    self.relationships.find_by(followed_id: other_user.id).destroy
  end

  private

  # 暗号化したトークンを作成
  # @return [string]
  def create_remeber_token
    # Userクラスのremember_tokenに値を代入するためにselfを使っている
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
