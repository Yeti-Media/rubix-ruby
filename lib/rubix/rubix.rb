class Rubix

  class ResponseError < Exception ; end
  class ServerError < Exception ; end
  class AuthorizationError < Exception ; end
  class ParseError < Exception ; end
  class JSONError < Exception ; end

  attr_accessor :client, :version, :access_token, :domain

  def initialize(access_token, version = 'v1', domain="http://api.rubix.io")
    self.access_token = access_token
    self.version = version
    self.client = Faraday.new(url: domain) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end
  end

  #data: {file: File, remote_file_url: "http://example.com/path/to/image", label: "uid", category_name: "matching"}
  def add_pattern(data)
    error_handler do
      result = client.post("/api/#{version}/patterns", {pattern: data, access_token: access_token})
      process_reponse(result)
    end
  end

  #data: {file: File, remote_file_url: "http://example.com/path/to/scene", mr: 0.9, mma: 150}
  def feature_matching(data)
    error_handler do
      result = client.post("/api/#{version}/patterns/feature_matcher", data.merge(access_token: access_token))
      process_reponse(result)
    end
  end

  #data: {file: File, remote_file_url: "http://example.com/path/to/scene", method: "corr|inter", min: 80, matching: 'gray|color|HSV'}
  def histogram(data)
    error_handler do
      result = client.post("/api/#{version}/patterns/histogram", data.merge(access_token: access_token))
      process_reponse(result)
    end
  end

  #data: {file: File, remote_file_url: "http://example.com/path/to/scene", rectangles: [[x1,y1.x2,y2],..,[x1,y1,x2,y2]]}
  def ocr(data)
    error_handler do
      result = client.post("/api/#{version}/patterns/ocr", data.merge(access_token: access_token))
      process_reponse(result)
    end
  end

  private

  def error_handler
    begin 
      yield
    rescue JSON::ParserError => e
      raise ParseError.new(e.message)
    rescue JSON::JSONError => e
      raise JSONError.new(e.message)
    end
  end

  def process_reponse(response)
    case response.status
    when 200
      JSON.parse(response.body) 
    when 401 
      raise AuthorizationError.new(JSON.parse(response.body)['error'])
    when 422
      raise ResponseError.new(JSON.parse(response.body)['error'])
    when 500
      raise ServerError.new
    end
  end

end
