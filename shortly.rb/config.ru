require 'grape'

module Shortly
  module Store
    @table=[]

    @base=36

    def self.encode i; i.to_s(@base); end
    def self.decode s; s.to_i(@base); end

    def self.shorten url
      exists = @table.find_index url
      if exists
        encode exists
      else
        @table << url
        encode(@table.length)
      end
    end

    def self.expand url
      @table.at decode(url)-1
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
