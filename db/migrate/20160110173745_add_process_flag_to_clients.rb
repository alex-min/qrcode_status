class AddProcessFlagToClients < ActiveRecord::Migration
  def change
    Client.all.map do |c|
      count = c.client_events.select {|e| e.event_code === 'repair_done' }.length
      if count > 0
        c.processed = true
        c.save
      end
    end
  end
end
