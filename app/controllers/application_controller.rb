class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

    def obtener_estado_funcionario(estado)

    case estado
    
      when 1 then 'Permanente'
      when 2 then 'Contratado'
      when 3 then 'Comisionado'
      when 4 then 'Ad-Honorem'

    end

  end


end
