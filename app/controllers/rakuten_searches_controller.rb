class RakutenSearchesController < ApplicationController
  def index
    if params[:keyword].present?
      items = RakutenWebService::Ichiba::Item.search(
        keyword: params[:keyword],
        hits:    10
      )
      render json: items.map { |i|
        {
          name:  i['itemName'],
          url:   i['affiliateUrl'],
          image: i['mediumImageUrls'].first
        }
      }
    else
      render json: []
    end
  end
end
