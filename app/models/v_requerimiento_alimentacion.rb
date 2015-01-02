class VRequerimientoAlimentacion < ActiveRecord::Base
  
  acts_as_xlsx

  scope :orden_dep_dis, :order => 'nombre_departamento, nombre_distrito,numero_prioridad,tipo_alimentacion_escolar'
  
  def uri_establecimiento
    "http://datos.mec.gov.py/id/establecimientos/#{self.codigo_establecimiento}"
  end
  
  def uri_institucion
    "http://datos.mec.gov.py/id/instituciones/#{self.codigo_institucion}"
  end
  
end
