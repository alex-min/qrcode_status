require "open-uri"

def spacing
  @pdf.text ' '
end

def draw_strokes
  @pdf.stroke_bounds
end

def company_header
  @pdf.bounding_box([0,750], width: 250) do
    @pdf.indent 10, 0 do
      @pdf.image @company.logo.path, width: 50
      @pdf.text @company.name
      @pdf.text "#{I18n.t('activerecord.attributes.company.address')}: #{@company.address}"
      @pdf.text "#{I18n.t('activerecord.attributes.company.siret')}: #{@company.siret}"
      @pdf.text "#{I18n.t('activerecord.attributes.company.phone')}: #{@company.phone}"
    end
    #pdf.stroke_bounds
  end
end

def client_info_block
  @pdf.bounding_box([250,750], :width => 250) do
    @pdf.indent 10, 0 do
      spacing
      @pdf.text "<b>#{I18n.t('client.view.info')}</b><br>", size: 13, inline_format: true
      @pdf.text "<b>#{I18n.t('activerecord.attributes.client.full_name')}</b>: #{@client.full_name}", inline_format: true
      @pdf.text "<b>#{I18n.t('activerecord.attributes.client.address')}</b>: #{@client.address} - #{@client.postal_code} #{@client.city}", :inline_format => true
      @pdf.text "<b>#{I18n.t('client.view.date')}</b>: #{@client.created_at.to_date}", inline_format: true
      @pdf.text "<b>#{I18n.t('activerecord.attributes.client.phone')}</b>: #{@client.phone}", inline_format: true
      @pdf.text "<b>#{I18n.t('activerecord.attributes.client.email')}:</b>: #{@client.email}", inline_format: true
      spacing
    end
    draw_strokes
  end
end

def product_type_block
  spacing
  spacing
  @pdf.text '<b>Produits en panne</b>', :size => 15, :inline_format => true
  spacing
  ProductType.where(company: @company).each do |product|
    @pdf.font "data/fonts/DejaVuSans.ttf" do
      checkbox = if @client.product == product.legacy_slug or @client.product === product.name
                   '☒'
                 else
                   '☐'
                 end
      @pdf.text "#{checkbox} #{product.name}"
    end
  end
  @pdf.text "<b>Marque</b>: #{@client.brand}", inline_format: true
  @pdf.text "<b>Modèle:</b> #{@client.product_name}", inline_format: true
  spacing
  qr_code
  details
end

def qr_code
  temfile = Tempfile.new('qrcode')
  qrcode = RQRCode::QRCode.new("https://status.microdeo.com#{status_path(@client.unique_id)}", size: 6, level: :h)
  qrcode.to_img.resize(85, 85).save(temfile.path)
  @pdf.image open(temfile.path), align: :right
  temfile.unlink
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
      @pdf.text 'Etat du materiel:', size: 15
      ProductState.where(company: @company).each do |state|
        checkbox = @client.product_state_id == state.id ? '☒' : '☐'
        @pdf.font 'data/fonts/DejaVuSans.ttf' do
          @pdf.text "#{checkbox} #{state.legacy_slug}", size: 13
        end
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
      spacing
      spacing
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
    [
      'Art 1.2 - Avis de mise à disposition',
      'Ø Lorsque votre appareil est disponible, vous êtes prévenu par un SMS.',
      '1.3 - Conditions de dépôt des produits',
      'Ø Vous devez impérativement déposer le ou les produits accompagnés de tous ses accessoires d’origine.',
      'Ø Vous déclarez disposer des originaux des logiciels installés sur votre matériel et les avoir acquis licitement.',
      'Ø Il vous appartient préalablement au dépôt de votre matériel à notre SAV de sauvegarder l\'ensemble des données. MicoDeo ne saurait en aucune façon',
      'être tenu pour responsable de toute perte ou altération de données qui pourraient survenir.',
      'Ø Le dépôt nécessite impérativement la signature du bon de dépôt. Aucune prestation ne pourra débuter sans la signature de ce bon.',
      'Ø L\'acceptation par MicroDeo du matériel et ou l\'absence de mention de la part de MicroDeo sur l\'état de l\'appareil ne saurait lier MicroDeo tant que cette dernière n\'a pas procédé au diagnostic de l\'état de l\'appareil.',
      '1.4 - Conditions de retrait du matériel',
      'Ø L\'appareil réparé est restitué uniquement sur présentation du bon de dépôt initial accompagné de la facture originale d\'achat.',
      'Ø La restitution se fait après complet paiement du prix de la réparation, et restitution de l\'appareil de prêt le cas échéant.',
      'Ø Tout appareil non-repris dans un délai de trois mois après que le client y ait été invité par appel téléphonique par le SAV sera considéré comme abandonné et le SAV pourra en disposer de plein droit comme bon lui semble, y compris en procédant à sa destruction.',
      '1.5 - Garantie des réparations et matériels',
      'Ø La garantie de MicroDeo couvre exclusivement les pièces et la main-d’œuvre à l\'exclusion de tout autre préjudice'
      ].each do |condition|
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
