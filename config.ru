require "./server"
use Rack::SSL if ENV["RACK_ENV"] == "production"
run Sinatra::Application
