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
    response = client.post '/reviews-v1', review_hash
    if response.status == 201
      url = response.headers[:location]
      data = client.raw_get url
      "http://crucible01.cerner.com/cru/#{data[:permaId][:id]}"
    else
      response
    end
  end

  def review_hash
    {
      :reviewData=>
      {
        :projectKey=>"PHAPPDEV-CR",
        :name=>"Example review.",
        :description=>"Description or statement of objectives for this example review.",
        :author=>{:userName=>"db020377"},
        :type=>"REVIEW",
        :allowReviewersToJoin=>true,
        :createDate=>"2014-07-22T11:05:32.359+0200",
        :dueDate=>"2014-07-22T11:05:32.359+0200"
      },
      :patch=>"~ code to review I just added ~!!!"
    }
  end
end

