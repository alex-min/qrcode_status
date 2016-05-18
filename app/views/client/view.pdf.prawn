require "open-uri"

def spacing(pdf)
  pdf.text ' '
end


def company_header(pdf)
  pdf.bounding_box([0,730], :width => 250) do
    pdf.indent 10, 0 do
      pdf.image "#{Rails.root}/public/images/microdeo-logo.png", width: 50
      pdf.text @company.name
      pdf.text "Addresse: #{@company.address}"
      pdf.text "Siret: #{@company.siret}"
    end
    #pdf.stroke_bounds
  end
end

def client_info_block(pdf)
  pdf.bounding_box([250,730], :width => 250) do
    pdf.indent 10, 0 do
      spacing(pdf)
      pdf.text '<b>Informations Client</b><br>', size: 13, inline_format: true
      pdf.text "<b>Nom</b>: #{@client.full_name}", inline_format: true
      pdf.text "<b>Adresse</b>: #{@client.address} - #{@client.postal_code} #{@client.city}", :inline_format => true
      pdf.text "<b>Date</b>: #{@client.created_at.to_date}", :inline_format => true
      pdf.text "<b>Téléphone</b>: #{@client.phone}", :inline_format => true
      spacing(pdf)
    end
    pdf.stroke_bounds
  end
end

def product_type_block(pdf)
  pdf.text 'Produits en panne', :size => 13
  spacing(pdf)
  ProductType.all.each do |product|
    pdf.font "data/fonts/DejaVuSans.ttf" do
      checkbox = @client.product == product.legacy_slug ? '☒' : '☐'
      pdf.text "#{checkbox} #{product.name}"
    end
  end
  pdf.text "<b>Marque</b>: #{@client.brand}", :inline_format => true
  pdf.text "<b>Modèle:</b> #{@client.product_name}", :inline_format => true
  pdf.image open('https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=http://status.microdeo.com/status/U6nUP4H4JlAnXXNaqdh7pg'), width: 80, align: :right
end

prawn_document(:page_layout => :portrait, size: 'A4') do |pdf|
  pdf.text 'FICHE DE PRISE EN CHARGE SAV', :size => 16, :align => :right
  company_header(pdf)
  client_info_block(pdf)
  product_type_block(pdf)
end
