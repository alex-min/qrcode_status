namespace :dataclean do
  desc "Recovers the company_id on clients"
  task companies_on_clients: :environment do
    Client.where(company_id: nil).map do |client|
      if client.user.present?
        client.company_id = client.user.company_id
      else
        client.company_id = Company.first.id
      end
      client.save!(validate: false)
    end
  end
  desc "Recovers the company_id on user_messages"
  task companies_on_user_messages: :environment do
    affected = UserMessage.where(company_id: nil).count
    UserMessage.where(company_id: nil).map do |user_message|
      if user_message.user.present?
        user_message.company = user_message.user.company
      else
        user_message.company = Company.first
      end
      user_message.save!
      puts "Added company #{user_message.company.name} to #{user_message.title}"
    end
    puts "Modified #{affected} UserMessages objects"
end
end
