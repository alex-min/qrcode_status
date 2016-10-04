raise ArgumentError.new('Env variable WEBSITE_HOSTNAME is mandatory') unless ENV['WEBSITE_HOSTNAME']

Rails.application.config.hostname = ENV['WEBSITE_HOSTNAME']
