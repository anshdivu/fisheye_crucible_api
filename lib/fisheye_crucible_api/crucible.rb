require "fisheye_crucible_api/http_client"

class Crucible
  attr_reader :base_url, :client

  def initialize(base_url = 'http://crucible01.cerner.com/')
  # def initialize(base_url = 'https://crucible.training.cerner.com/')
    @base_url = base_url
    @client = HttpClient.new(base_url)
  end

  def open_reviews
    client.get('/reviews-v1', state: 'Review')
  end

  def create_review

  end
end

