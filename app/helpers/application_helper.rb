module ApplicationHelper

	def mec_custom_url(url)
    if Rails.env.production?
      s = url.split("/")
      s.delete_at(s.index("data") || s.length)
      url = s.join('/')
    end
    url
  end

  def obtener_mes(mes)

    case mes
    when 1 then "enero"
    when 2 then "febrero"
    when 3 then "marzo"
    when 4 then "abril"
    when 5 then "mayo"
    when 6 then "junio"
    when 7 then "julio"
    when 8 then "agosto"
    when 9 then "setiembre"
    when 10 then "octubre"
    when 11 then "noviembre"
    when 12 then "diciembre"
    else ""
    end

  end

  def icon_delete
    image_tag("delete-icon.png", :style => "width:16px;")
  end
  
  def options_meses
    
    [["",""],["enero", 1],["febrero", 2],["marzo", 3], ["abril", 4], ["mayo", 5], ["junio", 6], ["julio", 7], ["agosto", 8], ["setiembre", 9], ["octubre", 10], ["novimiembre", 11], ["diciembre", 12]]

  end


  def descargar_documento(numero, anio, mes, tipo_documento)

    html = ""
    image_star = image_tag('star.png', :style => 'width:12px;padding-bottom:10px;')

      if anio.present?

        descarga_dataset = DescargaDataset.find_by("numero_dataset = ? and periodo = ? and mes =? and tipo_documento = ?", numero, anio, mes, tipo_documento)

        if descarga_dataset.present?

          if  Rails.env == "development"

            documento = descarga_dataset.url_development+"."+ tipo_documento

          elsif Rails.env == "production"

            documento = descarga_dataset.url_production+"."+ tipo_documento

          end

            
            if tipo_documento == "xlsx"

              html += link_to("XLS#{image_star * 2}".html_safe, documento , :target => "_blank", :style => "margin-left:10px;", :class => 'icon icon-page_excel', :itemprop => "url")
              html += " <br />"
              html += "<span style='color:silver;'>("+descarga_dataset.size+")</span>"

            elsif tipo_documento == "csv"

              html += link_to("CSV#{image_star * (numero == 11 || numero == 12 ? 4 : 3)}".html_safe, documento , :target => "_blank", :style => "margin-left:10px;", :class => 'icon icon-page', :itemprop => "url")
              html += " <br />"
              html += "<span style='color:silver;'>("+descarga_dataset.size+")</span>"

            elsif tipo_documento == "json"

              html += link_to("JSON#{image_star * (numero < 3 ? 4 : 3)}".html_safe, documento , :target => "_blank", :style => "margin-left:10px;", :class => 'icon icon-page_white_text_width', :itemprop => "url")
              html += " <br />"
              html += "<span style='color:silver;'>("+descarga_dataset.size+")</span>"

            elsif tipo_documento == "pdf"

              html += link_to("PDF#{image_star}".html_safe, documento , :target => "_blank", :style => "margin-left:10px;", :class => 'icon icon-page_white_acrobat', :itemprop => "url")
              html += " <br />"
              html += "<span style='color:silver;'>("+descarga_dataset.size+")</span>"

          end
        
        end

      end

      html.html_safe

  end

end
