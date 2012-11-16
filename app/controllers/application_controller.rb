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
end
