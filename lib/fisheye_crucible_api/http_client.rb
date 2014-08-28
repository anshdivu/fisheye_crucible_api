require 'faraday'
require 'json'

class HttpClient
  attr_reader :base_url

  def initialize(base_url)
    @base_url = base_url
  end

  def get(url, params = {})
    data = connection.get('/rest-service' + url, params)
    JSON.parse(data.body, symbolize_names: true) if data.success?
  end

  def raw_get(url)
    connection = Faraday.new(params: auth_params, headers: default_headers) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    data = connection.get url

    JSON.parse(data.body, symbolize_names: true) if data.success?
  end

  def post(url, body = {})
    connection.post('/rest-service' + url, body.to_json)
  end

  def connection
    @connection ||= Faraday.new(url: base_url, params: auth_params, headers: default_headers) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def auth_params
    @auth_params ||= {'FEAUTH' => "db020377:10845:d4be91cad7eb8d1e8209b9529e65919e"} # cerner
    # @auth_params ||= {'FEAUTH' => "db020377:9689:bcdd077dc1fb83996b8153035874879c"} #devcenter
  end

  def default_headers
    @default_headers ||= {'content-type' => 'application/json', 'accept'=>'application/json'}
  end

end

# require "httparty"
# url = 'https://crucible.training.cerner.com/rest-service/auth-v1/login'
# response = HTTParty.get(url, query: {userName: 'db020377', password: 'Summer2014'}); response.code
