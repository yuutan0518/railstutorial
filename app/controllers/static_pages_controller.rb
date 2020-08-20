class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # ログインしてたらマイクロポストのインスタンス変数を定義
      @micropost = current_user.microposts.build
      # 一覧表示
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
