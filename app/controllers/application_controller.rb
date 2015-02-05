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
    cadena = cadena.gsub(/[áàâãÁÀÂÃ]/, 'a').downcase
    cadena = cadena.gsub(/[éèẽêÉÈÊẼ]/, 'e').downcase
    cadena = cadena.gsub(/[íìĩîÍÌÎĨ]/, "i").downcase
    cadena = cadena.gsub(/[óòõôÓÒÔÕ]/, "o").downcase
    cadena = cadena.gsub(/[úùũûÚÙÛŨ]/, "u").downcase
    cadena = cadena.gsub(/[ỹỸ]/, "y").downcase
    return cadena
  end
  
  def autocompletar
    html = ""

    if params[:term].present?

      hashes = {}
      if params[:model] == 'PersonaFull'
     
        hashes[:conditions] = ["#{( params[:cadena_consulta].present? ? params[:cadena_consulta] : params[:atributo_descripcion] ) } = ?", "#{params[:term].upcase}"]

      else
     
        hashes[:conditions] = ["#{( params[:cadena_consulta].present? ? params[:cadena_consulta] : params[:atributo_descripcion] ) } like ?", "%#{params[:term].upcase}%"]
     
      end
      
      hashes[:order] = params[:orden] if params[:orden].present?
      hashes[:limit] = params[:limit].to_i if params[:limit].present?
      
      resultados = params[:model].constantize.where(hashes[:conditions]).uniq.pluck(params[:cadena_consulta]).take(hashes[:limit])

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

end
