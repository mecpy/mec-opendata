class VRequerimientoOtroEspacio < ActiveRecord::Base
  
  self.table_name = "v_requerimientos_otros_espacios"
  
  self.primary_key = :periodo, :numero_prioridad, :codigo_distrtito

  scope :orden_dep_dis, -> { order('nombre_departamento, nombre_distrito, numero_prioridad')}
  
  def uri_establecimiento
    "http://datos.mec.gov.py/id/establecimientos/#{self.codigo_establecimiento}"
  end
  
  def uri_institucion
    "http://datos.mec.gov.py/id/instituciones/#{self.codigo_institucion}"
  end
  
end
