require 'minitest/autorun'

require_relative '../lib/store'

class StoreSpec < MiniTest::Spec

  before do
    @url = "test_url"
    Shortly::Store.init "test"
  end

  after do
    Shortly::Store.kill "test"
  end

  describe "Immutables" do
    it "encodes" do
      assert_equal Shortly::Store.encode(1234), "ya"
    end

    it "decodes" do
      assert_equal Shortly::Store.decode("ya"), 1234
    end
  end

  describe "DB Operations" do
    it "saves" do
      Shortly::Store.save(@url)
      assert_equal Shortly::Store.find_id(@url), 1
    end
  end

  describe "Service Operations" do
    it "shortens a url" do
      assert_equal Shortly::Store.shorten(@url), "1"
    end

    it "expands a url" do
      id = Shortly::Store.shorten @url
      assert_equal Shortly::Store.expand(id), @url
    end
  end

end
