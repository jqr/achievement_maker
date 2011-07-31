require "rubygems"
require "bundler"
Bundler.setup(:default)

require './achievement'
require 'sinatra'

get "/xbox/:text" do
  content_type 'image/png'
  achievement(params[:header] || 'ACHIEVEMENT ULOCKED', params[:text]).to_blob
end
