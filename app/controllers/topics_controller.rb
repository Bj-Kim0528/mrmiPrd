class TopicsController < ApplicationController
  def show
    @theme = params[:theme]
    # 테마가 a, b, c, d 중 하나인지 검증할 수도 있습니다.
    @card_collections = CardCollection.where(theme: @theme)
  end

  def hashtag_channel
    @hashtags = Hashtag.all
  end
end
