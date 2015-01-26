class Establecimiento111 < ActiveRecord::Base
	
  self.table_name = "v_proyecto_111"
  
  scope :orden_dep_dis, -> { order('nombre_departamento, nombre_distrito')}

  def uri
    "http://datos.mec.gov.py/id/establecimientos/#{self.codigo_establecimiento}"
  end

  def codigo_establecimiento_
    "#{self.codigo_establecimiento} "
  end

end