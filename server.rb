require "bundler"
Bundler.require(:default, :server)

require "./achievement"
require "erb"

env = ENV["RACK_ENV"] || "development"

def remove_image_suffix(value)
  value.to_s.sub(/\.(jpeg|jpg|png|gif)$/i, "")
end

get "/xbox/:text" do
  achievement = remove_image_suffix(params[:text])
  header = remove_image_suffix(params[:header] || "ACHIEVEMENT UNLOCKED")
  email = remove_image_suffix(params[:email])
  player = remove_image_suffix(params[:player] || "1").to_i

  if env == "production"
    response["Cache-Control"] = "public, max-age=#{60*24*30}" # 30 day cache
  end

  content_type "image/png"
  Achievement.new(achievement:, header:, email:, player:).to_blob
end

get "/" do
  erb :index
end
