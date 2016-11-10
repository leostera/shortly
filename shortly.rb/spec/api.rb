require 'rack/test'
require 'minitest/autorun'

require_relative '../lib/api'
require_relative '../lib/store'

class Shortly::APITest < MiniTest::Test

  include Rack::Test::Methods

  def app
    Shortly::API
  end

  def setup
    Shortly::Store.init("api_test")
  end

  def teardown
    Shortly::Store.kill("api_test")
  end

  def test_shortening_a_url_returns_404_on_empty_db
    get '/api/url/10'
    assert_equal 404, last_response.status
  end

  def test_shortening_a_url_returns_key
    post '/api/url', { url: "test" }
    res = JSON.parse(last_response.body)
    assert_equal "test", res["long"]
    assert_equal "1", res["short"]
  end

  def test_expanding_a_key_returns_a_url
    post '/api/url', { url: "test" }
    get '/api/url/1'
    assert last_response.ok?
  end

end
