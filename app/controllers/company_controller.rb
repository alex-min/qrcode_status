class CompanyController < ApplicationController
  include Authenticated

  def index
    @companies = Company.all
  end
end
