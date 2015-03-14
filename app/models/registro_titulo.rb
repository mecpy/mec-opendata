class RegistroTitulo < ActiveRecord::Base
   
  self.table_name = "registros_titulos"

  scope :orden_anio_mes, -> { order('anio, mes')}

  def gobierno_actual

    (self.anio == 2013 && self.mes >= 8) || (self.anio > 2013) ? 'Si' : 'No'

  end

end
