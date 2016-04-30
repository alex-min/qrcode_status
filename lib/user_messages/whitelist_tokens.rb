class UserMessages::WhitelistTokens
  def self.get
    [
      '<%= company.name %>',
      '<%= client.full_name %>'
    ]
  end

  def self.valid?(message)
    message = message.dup
    get.each do |token|
      message.gsub!(token, '_replaced_')
    end
    message.index('<%') == nil
  end
end
