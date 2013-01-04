class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate

  private
  def authenticate
    user = ENV['username'] || "ping"
    pass = ENV['password'] || "pong"
    unless Rails.env.test?
      authenticate_or_request_with_http_basic do |username, password|
        username == user && password == pass
      end
    end
  end

  def post_to_hipchat(message)
    client = HipChat::Client.new(ENV['HIPCHAT_TOKEN'])
    client[App.hipchat[:room]].send(App.hipchat[:username], message)
  end
end
