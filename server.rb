#!/usr/bin/env ruby

require "rubygems"
require "bundler"
Bundler.setup(:default)

require './achievement'
require 'sinatra'
require 'erb'
require 'instrumental_agent'

I = Instrumental::Agent.new('7f51dd0b9bdb8a08b978ccbf94509914', :start_reactor => false)

get "/xbox/:text" do
  I.increment('generate_image')
  content_type 'image/png'
  response['Cache-Control'] = "public, max-age=#{60*24*7}" # cache for one week
  achievement = params[:text].to_s.sub(/\.(jpeg|jpg|png|gif)$/i, '')
  header = (params[:header] || 'ACHIEVEMENT UNLOCKED').to_s.sub(/\.(jpeg|jpg|png|gif)$/i, '')
  email = params[:email].to_s.sub(/\.(jpeg|jpg|png|gif)$/i, '')
  achievement(header, achievement, email).to_blob
end

get "/" do
  I.increment('visit.homepage')
  erb :index
end
