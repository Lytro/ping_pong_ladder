class App < Configurable # :nodoc:
  # Settings in config/app/* take precedence over those specified here.
  config.name = Rails.application.class.parent.name

  config.hipchat = {
    room: "ping pong",
    username: "Pong.Lytro.com"
  }
end
