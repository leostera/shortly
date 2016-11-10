require 'sqlite3'

module Shortly
  module Store
    @db=nil

    def self.init name
      @db= SQLite3::Database.new "#{name}.db"
      @db.execute "CREATE TABLE IF NOT EXISTS urls
        (id integer primary key,
         url text)"
      @db
    end

    def self.kill name
      `rm #{name}.db`
    end

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
        find_id url
      end
    end

    def self.shorten url
      encode find_or_create(url)
    end

    def self.expand id
      find_url decode(id)
    end

  end
end
