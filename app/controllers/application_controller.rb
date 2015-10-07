class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :redireccionar_uri

  def obtener_estado_funcionario(estado)

    case estado
    
    when 1 then 'Permanente'
    when 2 then 'Contratado'
    when 3 then 'Comisionado'
    when 4 then 'Ad-Honorem'

    end

  end

  def redireccionar_uri
    
    if Rails.env.development?

      if request.url.to_s.include? '/id/'

        url = request.url.to_s.sub('/id/', '/doc/')

        redirect_to url

      end

    end
  
  end
  
  def quita_acentos( cadena )
    cadena = cadena.gsub(/[áàâãäÁÀÂÃÄ]/, 'a').downcase
    cadena = cadena.gsub(/[éèêẽëÉÈÊẼË]/, 'e').downcase
    cadena = cadena.gsub(/[íìîĩïÍÌÎĨÏ]/, "i").downcase
    cadena = cadena.gsub(/[óòôõöÓÒÔÕÖ]/, "o").downcase
    cadena = cadena.gsub(/[úùûũüÚÙÛŨÜ]/, "u").downcase
    cadena = cadena.gsub(/[ýỳŷỹÿÝỲŶỸŸ]/, "y").downcase
    return cadena
  end
  
  def autocompletar
      
    html = ""
    
    if params[:term].present?
      
      params[:term] = quita_acentos(params[:term])
      
      hashes = {}
      if params[:model] == 'PersonaFull'
     
        hashes[:conditions] = ["#{( params[:cadena_consulta].present? ? params[:cadena_consulta] : params[:atributo_id] ) } = ?", "#{params[:term].upcase}"]

      elsif params[:model] == 'VNomina'
        if params[:atributo_tipo] == 'int'
          hashes[:conditions] = ["#{( params[:cadena_consulta_adicional] ) } and CAST(#{ params[:cadena_consulta] } AS TEXT) like ?", "%#{params[:term].upcase}%"]
        else
          hashes[:conditions] = ["#{( params[:cadena_consulta_adicional] ) } and #{( params[:cadena_consulta].present? ? params[:cadena_consulta] : params[:atributo_id] ) } like ?", "%#{params[:term].upcase}%"]
        end
      else
        if params[:atributo_tipo] == 'int'
          hashes[:conditions] = ["CAST(#{ params[:cadena_consulta] } AS TEXT) like ?", "%#{params[:term].upcase}%"]
        else
          hashes[:conditions] = ["#{( params[:cadena_consulta].present? ? params[:cadena_consulta] : params[:atributo_id] ) } like ?", "%#{params[:term].upcase}%"]
        end
     
      end
      
      hashes[:order] = params[:orden] if params[:orden].present?
      hashes[:limit] = params[:limit].to_i if params[:limit].present?
      
      resultados = params[:model].constantize.where(hashes[:conditions]).order(hashes[:order]).uniq.pluck(params[:atributo_id]).take(hashes[:limit])

      if resultados.present?
        
        resultados.each do |objeto|

          html += "{\"id\":\"#{eval("objeto")}\","
          html += "\"label\":\"#{eval("objeto")}\","
          html += "\"value\":\"#{eval("objeto")}\"},"

        end
        
      end

    end

    respond_to do |f|

      f.html { render :text => "[#{html[0..html.size-2]}]".html_safe }

    end

  end

  def generate_pdf(content, name)
    Prawn::Document.new(:page_layout => :landscape) do
      text name, :size => 20
      data = [['Nombre', 'Descripción', 'Tipo', 'Restricciones', 'Referencia', 'Ejemplo']]
      content.each do |row|
        data += [[row['nombre'], row['descripcion'], row['tipo'], row['restricciones'],
        make_cell(:content => "<link href='#{row['referencia']['enlace']}'>#{row['referencia']['texto']}</link>",
          :inline_format => true),
        (row['ejemplo'] == 'url_anho_cod_geo') ? make_cell(:content => "<link href='http://datos.mec.gov.py/def/ejemplo_anio_cod_geo'>Ver ejemplo</link>",
          :inline_format => true) : row['ejemplo']]]
      end
      table(data, :header => true, :row_colors => ["F0F0F0", "FFFFFF"], :width => 715,
        :column_widths => {0 => 100, 1 => 245, 2 => 70, 3 => 100, 4 => 100, 5 => 100},
        :cell_style => {:border_color => "FFFFFF"}) do
          style row(0), :background_color => "4F5B95", :font_style => :bold, :text_color => "FFFFFF"
      end
    end.render
  end

  def clean_json(content)
    content.each do |row|
      row['tipo'] = case row['tipo']
        when "xsd:gYear", "xsd:positiveInteger" then "integer"
        when "xsd:string" then "string"
        when "xsd:boolean" then "boolean"
        when "xsd:datetime" then "datetime"
        else ""
      end
    end
    return content
  end

  def generate_json_table_schema(content)

    json_table_schema =
    "{\n" +
    "    \"fields\": ["

    len = content.length
    content.each_with_index do |row, index|

      json_table_schema +=
      "\n        {\n" +
      "            \"name\": " + ((row['nombre'] == "") ? "\"\"" : ("\"" + row['nombre'] + "\"") ) + ",\n" +
      "            \"title\": " + ((row['nombre'] == "") ? "\"\"" : ("\"" + (row['nombre'].capitalize).gsub("_", " ") + "\"") ) + ",\n" +
      "            \"example\": " + ((row['ejemplo'] == "") ? "\"\"" : ("\"" + row['ejemplo'] + "\"") ) + ",\n" +
      "            \"type\": " + ((row['type'] == "") ? "null" : ("\"" + row['tipo'] + "\"") ) + ",\n" +
      "            \"restrictions\": " + ((row['restricciones'] == "") ? "\"\"" : ("\"" + row['restricciones'] + "\"") ) + ",\n" +
      "            \"description\": " + ((row['descripcion'] == "") ? "\"\"" : ("\"" + row['descripcion'] + "\"") ) + "\n" +
      "        }" + ((index+1 == len) ? "\n" : ",")

    end

    json_table_schema +=
        "    ]\n"+
    "}"
    respond_to do |f|

      f.js
      f.json {render :json => json_table_schema}

    end

  end

  def generate_md5(path_file)

    md5 = Digest::MD5.file(path_file).hexdigest
    return md5
    
  end

end
