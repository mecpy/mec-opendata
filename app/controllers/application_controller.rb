class ApplicationController < ActionController::Base
  protect_from_forgery


  def obtener_estado_funcionario(estado)

    case estado
    
      when 1 then 'Permanente'
      when 2 then 'Contratado'
      when 3 then 'Comisionado'
      when 4 then 'Ad-Honorem'

    end

  end

end
