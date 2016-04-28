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
end
