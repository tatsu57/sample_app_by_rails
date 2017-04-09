class User < ActiveRecord::Base

  before_save { self.email = email.downcase}

  validates :name , presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # :case_sensitiveを付けることで、大文字小文字を無視した一意の判定ができる。
  validates :email,
    presence: true,
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  # railsがセキュアなパスワードを生成するためのメソッド。詳細は以下のURL
  # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
  has_secure_password
  validates :password, length: { minimum: 6 }
end
