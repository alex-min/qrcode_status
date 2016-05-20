class UserMessages::WhitelistTokens
  def self.token_list
    [
      '<%= company.name %>',
      '<%= client.full_name %>',
      '<%= client.product_full_name %>'
    ]
  end

  def self.valid?(message)
    message = message.dup
    token_list.each do |token|
      message.gsub!(token, '_replaced_')
    end
    message.index('<%') == nil
  end

  def self.i18n_replace(message)
    token_list.each do |token|
      replacement = '<span class="user-message-token">' +
                    I18n.t("user_message.token.#{token.delete('<>=% ')}") +
                    '</span>'
      message.gsub!(token, replacement)
    end
    message
  end
end
