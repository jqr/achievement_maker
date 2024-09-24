#!/usr/bin/env ruby

require "rubygems"
require "bundler"
Bundler.setup(:default)

require "./achievement"
require "sinatra"
require "erb"

env = ENV['RACK_ENV'] || 'development'

get "/xbox/:text" do
  content_type "image/png"
  response["Cache-Control"] = "public, max-age=#{60*24*7}" # cache for one week
  achievement = params[:text].to_s.sub(/\.(jpeg|jpg|png|gif)$/i, '')
  header = (params[:header] || "ACHIEVEMENT UNLOCKED").to_s.sub(/\.(jpeg|jpg|png|gif)$/i, '')
  email = params[:email].to_s.sub(/\.(jpeg|jpg|png|gif)$/i, '')
  achievement(header, achievement, email:).to_blob
end

get "/" do
  erb :index
end
