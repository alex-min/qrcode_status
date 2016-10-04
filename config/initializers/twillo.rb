unless ENV['TWILLO_ACCOUNT_SID'] and ENV['TWILLO_AUTH_TOKEN'] and ENV['TWILLO_ROOT_PHONE']
  raise ArgumentError.new('Env variables TWILLO_ACCOUNT_SID, TWILLO_AUTH_TOKEN and TWILLO_ROOT_PHONE are required')
end
