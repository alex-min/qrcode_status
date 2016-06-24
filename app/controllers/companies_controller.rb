class CompaniesController < ApplicationController
  include Authenticated

  def add_new

  end

  def index
    @companies = Company.all
  end
end
