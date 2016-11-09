require 'grape'

module Shortly
  module Store
    @table=[]

    def self.shorten url
      @table << url
      @table.length.to_s 32
    end

    def self.expand url
      @table.at url.to_i(32)-1
    end

  end

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
        }.to_json
      end

      route_param :url do
        desc 'Expand a url'
        get do
          long = Shortly::Store::expand(params[:url])
          if short.nil?
            status :no_content
          else
            {
              long: long,
              short: params[:url]
            }.to_json
          end
        end
      end
    end

  end
end

run Shortly::API
