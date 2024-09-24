require "digest/md5"
require "http"
require "uri"

class Gravatar
  DEFAULT_DIMENSIONS = 46

  attr_reader :email

  def initialize(email)
    @email = email
  end

  def image_data(dimensions: DEFAULT_DIMENSIONS)
    HTTP.get("https://www.gravatar.com/avatar/#{email_hash}", params: { s: dimensions, d: "mm" }).body
  end

  def email_hash
    Digest::MD5.hexdigest(email.downcase.strip)
  end

  def self.get(email, dimensions: 46)
    client = Faraday::Connection.new(:url => "https://www.gravatar.com/")
    hash = Digest::MD5.hexdigest(email.downcase.strip)
    client.get("/avatar/#{hash}?s=#{dims}&d=mm").body
  end
end
