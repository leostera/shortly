require 'sqlite3'
require 'grape'

module Shortly
  module Store
    @db = SQLite3::Database.new "shortly.db"
    @db.execute "CREATE TABLE IF NOT EXISTS urls
      (id integer primary key,
       url text)"

    @base=36

    def self.encode i; i.to_s(@base); end
    def self.decode s; s.to_i(@base); end

    def self.find_url id
      res = @db.execute("select * from urls where id=?", id)
      res[0][1] unless res.empty?
    end

    def self.find_id url
      res = @db.execute("select * from urls where url=?", url)
      res[0][0] unless res.empty?
    end

    def self.save url
      @db.execute("insert into urls values (NULL, ?)", url)
    end

    def self.find_or_create url
      exists = find_id url
      if exists
        exists
      else
        save url
        find_or_create url
      end
    end

    def self.shorten url
      encode find_or_create(url)
    end

    def self.expand id
      find_url decode(id)
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
          if long.nil?
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
