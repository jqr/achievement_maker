require "rubygems"
require "bundler"
Bundler.setup(:default)

require './achievement'
require 'sinatra'
require 'erb'

get "/xbox/:text" do
  content_type 'image/png'
  achievement(params[:header] || 'ACHIEVEMENT ULOCKED', params[:text]).to_blob
end

get "/" do
  erb :index
end