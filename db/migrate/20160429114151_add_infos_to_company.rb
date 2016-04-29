class AddInfosToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :siret, :string
    add_column :companies, :phone, :string
    add_column :companies, :address, :text
  end
end
