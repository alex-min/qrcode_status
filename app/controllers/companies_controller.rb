class CompaniesController < ApplicationController
  include Authenticated

  def index
    @companies = Company.all
  end
end
