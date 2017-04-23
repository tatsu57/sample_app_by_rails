class MicropostsController < ApplicationController

  before_action :signed_in_user, only: [:create, :destroy]
  before_action :corrent_user, only: :destroy

  def create
    # @note ログインしていれば、current_userが使えるはず
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private_methods

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def corrent_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
