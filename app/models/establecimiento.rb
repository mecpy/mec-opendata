class Establecimiento < ActiveRecord::Base

  self.table_name = 'establecimientos'

  scope :orden_dep_dis, -> { order('nombre_departamento, nombre_distrito')}
  
  def uri
    "http://datos.mec.gov.py/id/establecimientos/#{self.codigo_establecimiento}"
  end
  
end
