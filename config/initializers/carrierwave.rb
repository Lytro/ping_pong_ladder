CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => ENV['AWS_KEY'],                        # required
    :aws_secret_access_key  => ENV['AWS_SECRET']                        # required
  }
  config.fog_directory  = "sc-pong-#{Rails.env}"                     # required
  config.cache_dir = "#{Rails.root}/tmp/uploads"
end

CarrierWave.configure do |config|
  config.storage = ['development', 'test'].include?(Rails.env) ? :file : :fog
  if Rails.env.test?
    config.enable_processing = false
  end
end
