class CompaniesController < ApplicationController
  include Authenticated

  def authorize(params)
    params.require(:company).permit(
      :name,
      :website,
      :siret,
      :phone,
      :address,
      :logo
    )
  end

  def assign
    redirect_to clients_path unless current_user.company.demo
    if request.request_method === 'POST'
      Company::Creator.new(user: current_user, company_data: authorize(params)).assign
      redirect_to clients_path
    else
      @company = Company.new
    end
  rescue ActiveRecord::RecordInvalid => e
    @company = e.record
  end

  def edit
    redirect_to companies_assign_path if current_user.company.demo
    @company = current_user.company
    if request.request_method === 'PATCH'
      @company.update_attributes!(authorize(params))
      add_info_message(I18n.t('companies.assign.updated'))
    end
  rescue ActiveRecord::RecordInvalid => e
    @company = e.record
  end

  def index
    @companies = Company.all
  end
end
