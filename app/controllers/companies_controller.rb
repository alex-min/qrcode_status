class CompaniesController < ApplicationController
  include Authenticated

  def authorize(params)
    params.require(:company).permit(
      :name,
      :website,
      :siret,
      :phone,
      :address
    )
  end

  def assign
    redirect_to clients_path unless current_user.company.demo
    if request.request_method === 'POST'
      ActiveRecord::Base.transaction do
        @company = Company.create!(authorize(params))
        current_user.company = @company
        current_user.save!
        redirect_to clients_path
      end
    else
      @company = Company.new
    end
  rescue ActiveRecord::RecordInvalid => e
    @company = e.record
  end

  def edit
  end

  def index
    @companies = Company.all
  end
end
