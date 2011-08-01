#!/usr/bin/env ruby

require "rubygems"
require "bundler"
Bundler.setup(:default)

require './achievement'
require 'sinatra'
require 'erb'

get "/xbox/:text" do
  content_type 'image/png'
  response['Cache-Control'] = "public, max-age=#{60*24*7}" # cache for one week
  achievement(params[:header] || 'ACHIEVEMENT UNLOCKED', params[:text]).to_blob
end

get "/" do
  erb :index
end