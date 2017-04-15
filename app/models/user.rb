class User < ActiveRecord::Base

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

  private

  # 暗号化したトークンを作成
  # @return [string]
  def create_remeber_token
    # Userクラスのremember_tokenに値を代入するためにselfを使っている
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
