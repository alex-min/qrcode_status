require "open-uri"

def spacing(times: 1)
  (1..times).each { @pdf.text ' ' }
end

def draw_strokes
  @pdf.stroke_bounds
end

def company_header
  @pdf.bounding_box([0,750], width: 250) do
    @pdf.indent 10, 0 do
      @pdf.image @company.logo.path, width: 50 if @company.logo.path
      @pdf.text @company.name
      @pdf.text "#{Company.human_attribute_name(:address)}: #{@company.address}"
      @pdf.text "#{Company.human_attribute_name(:siret)}: #{@company.siret}"
      @pdf.text "#{Company.human_attribute_name(:phone)}: #{@company.phone}"
    end
  end
end

def client_info_block
  @pdf.bounding_box([250,750], :width => 250) do
    @pdf.indent 10, 0 do
      spacing
      @pdf.text "<b>#{I18n.t('client.view.info')}</b><br>", size: 13, inline_format: true
      show_attribute(Client.human_attribute_name(:full_name), @client.full_name)
      show_attribute(Client.human_attribute_name(:address), @client.full_address)
      show_attribute(I18n.t('client.view.date'), @client.created_at.to_date)
      show_attribute(Client.human_attribute_name(:phone), @client.phone)
      show_attribute(Client.human_attribute_name(:email), @client.email)
      spacing
    end
    draw_strokes
  end
end

def show_attribute(attribute, text)
  @pdf.text "<b>#{attribute}</b>: #{text}", inline_format: true
end

def product_type_block
  spacing(times: 2)
  @pdf.text "<b>#{I18n.t('client.view.broken_products_list')}</b>", size: 15, inline_format: true
  spacing
  @pdf.font "data/fonts/DejaVuSans.ttf" do
    @pdf.text "☒ #{@client.product}"
  end
  spacing
  show_attribute(Client.human_attribute_name(:brand), @client.brand)
  show_attribute(Client.human_attribute_name(:product_name), @client.product_name)
  spacing
  qr_code
  details
end

def qr_code
  temfile = Tempfile.new('qr_code')
  qrcode = RQRCode::QRCode.new(qr_code_url, size: 6, level: :h)
  qrcode.to_img.resize(85, 85).save(temfile.path)
  @pdf.image open(temfile.path), align: :right
  temfile.unlink
end

def qr_code_url
  "https://#{ENV['WEBSITE_HOSTNAME']}/#{status_path(@client.unique_id)}"
end

def problem_block
  @pdf.bounding_box([250,620], width: 250) do
    @pdf.indent 10, 0 do
      spacing
      @pdf.text 'Panne constatée :'
      @pdf.text @client.panne
      spacing
    end
  end
end

def product_state
  @pdf.bounding_box([250,520], width: 250) do
    @pdf.indent 10, 0 do
      spacing
      @pdf.text I18n.t('client.view.product_state'), size: 15
      @pdf.font "data/fonts/DejaVuSans.ttf" do
        @pdf.text "☒ #{@client.product_state.name}", size: 13
      end
      spacing
    end
    draw_strokes
  end
end

def client_signature
  @pdf.bounding_box([250,370], width: 250) do
    @pdf.indent 10, 0 do
      spacing
      @pdf.text I18n.t('client.view.signature')
      spacing(times: 2)
    end
    draw_strokes
    spacing
    @pdf.text 'Vous déclarez avoir pris connaissance des conditions générales.', size: 10
    @pdf.text 'Nous déclinons toutes responsabilités en cas de perte de données.', size: 10
  end
  conditions
end

def conditions
  @pdf.bounding_box([0, @pdf.cursor - 10], width: 500) do
    (@company.terms || '').split('\n').each do |condition|
      @pdf.text condition, size: 9
    end
  end
end

def details
  @pdf.bounding_box([0,@pdf.cursor - 10], width: 250) do
    @pdf.text 'Montant des devis (Déductible du montant total de la réparation en cas d’acceptation) :
  Informatique : 39 €  Téléphonie : 19€'
    spacing
    @pdf.text 'MicroDeo: Dépannage informatique et téléphonie, vente et réparation de Pc, Pc portable, Smartphones, Assemblage de PC selon vos besoins, Formatage, Nettoyage et Déblocage de smartphone toute marque. ', size: 10
  end
end

prawn_document(:page_layout => :portrait, size: 'A4') do |pdf|
  @pdf = pdf
  @pdf.text I18n.t('client.view.sav'), :size => 16, :align => :right
  company_header
  client_info_block
  product_type_block
  problem_block
  product_state
  client_signature
end
