require 'grape'

require_relative 'store'

module Shortly
  class API < Grape::API
    version 'v1', using: :header, vendor: 'shortly'
    format :json
    prefix :api

    resource :url do
      params do
        requires :url, type: String, desc: 'url'
      end

      desc 'Shorten a url'
      post do
        {
          long: params[:url],
          short: Shortly::Store::shorten(params[:url])
        }
      end

      route_param :url do
        desc 'Expand a url'
        get do
          long = Shortly::Store::expand(params[:url])
          if long.nil?
            status :not_found
          else
            {
              long: long,
              short: params[:url]
            }
          end
        end
      end
    end

  end
end
