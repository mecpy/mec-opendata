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
    cadena = cadena.downcase.gsub(/[éèẽêÉÈÊẼ]/, 'e').downcase
    cadena = cadena.downcase.gsub(/[íìĩîÍÌÎĨ]/, "i").downcase
    cadena = cadena.downcase.gsub(/[óòõôÓÒÔÕ]/, "o").downcase
    cadena = cadena.downcase.gsub(/[úùũûÚÙÛŨ]/, "u").downcase
    cadena = cadena.downcase.gsub(/[ỹỸ]/, "y").downcase
    return cadena
  end

end
