require "faraday"

module LoadData
  Error = Class.new(RuntimeError)

  BASE_URL = "https://api.airtable.com/v0/"
  HEADERS = { "Content-Type" => "application/json" }
  APIKEY = env["AIRTABLE_APIKEY"]
  Id = env["AIRTABLE_Id"]

  class << self
    def get
      res = Faraday.new(url: BASE_URL + Id).get { |request| request.headers.merge!(headers) }
      return res.body if res.status == 200
      raise Error.new("Unexpected Airtable error. status: #{res.status}, body: #{res.body}")
    end

    private

    def headers
      HEADERS.merge("Authorization" => "Bearer #{APIKEY}")
    end
  end
end
