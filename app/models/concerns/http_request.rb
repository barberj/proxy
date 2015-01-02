module HttpRequest
  extend ActiveSupport::Concern

  def request(method, url, options)
    Requests.http(method, url, options)
  end
end
