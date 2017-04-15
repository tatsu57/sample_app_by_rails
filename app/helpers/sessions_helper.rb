module SessionsHelper

  # サインイン時にすべてのコントローラーで読み込まれるメソッド
  # @note トークンを暗号化して、Userテーブルのremember_tokenを更新する
  # @param [User] user
  # @see [string] new_remember_token 新しいトークンを発行
  # @see [string] encrypt トークンを暗号化
  def sign_in(user)
    p remember_token = User.new_remember_token
    #cookies.permanentでブラウザのcookiesに保存
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  # @note メソッド名の最後に=を付けるとインスタンス変数にできる
  # 使い方: self.current_userをするとこのメソッドを呼ばれる
  # 自動で引数にuserが入る
  # @param [User] user Userオブジェクト
  def current_user=(user)
    @current_user = user
  end

  # 現在のユーザー情報を返す
  # @note cookieから取得したremember_tokenがUserテーブルからremember_tokenと合致するデータがあれば、現在のユーザーとして返す
  # @see [string] encrypt トークンを暗号化
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end
