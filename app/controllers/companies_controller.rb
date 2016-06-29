class CompaniesController < ApplicationController
  include Authenticated

  def assign
    redirect_to clients_path unless current_user.company.demo
  end

  def index
    @companies = Company.all
  end
end
