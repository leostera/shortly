require 'grape'

module Shortly
  class API < Grape::API
    version 'v1', using: :header, vendor: 'shortly'
    format :json
    prefix :api

    resource :url do
      params do
        requires :url, type: String, desc: 'url'
      end

      route_param :url do
        desc 'Expand  a url'
        get do
          p params[:url]
        end

        desc 'Shorten a url'
        post do
          p params[:url]
        end
      end
    end

  end
end

run Shortly::API
