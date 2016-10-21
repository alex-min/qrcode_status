if ENV['SENTRY_DSN'].present?
  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.environments = %w(staging production)
  end
end

Rails.application.config.sentry_dsn_frontend = ENV['SENTRY_DSN_FRONTEND']
