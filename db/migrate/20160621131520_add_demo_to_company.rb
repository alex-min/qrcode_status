class AddDemoToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :demo, :boolean
  end
end
