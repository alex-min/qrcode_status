class AddCompanyToClient < ActiveRecord::Migration
  def change
    add_reference :clients, :company, index: true, foreign_key: true
  end
end
