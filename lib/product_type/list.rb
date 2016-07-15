class ProductType::List
  def self.select_options(params)
    ProductType.where(company: params[:company]).all.map do |type|
      [type.name, type.name]
    end
  end
end
