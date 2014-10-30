class ApplicationController < ActionController::Base
  protect_from_forgery

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

end
