class VDirectorioInstitucion < ActiveRecord::Base

  self.table_name = "v_directorios_instituciones"
  
  self.primary_key = :periodo, :codigo_establecimiento, :codigo_institucion
  
  scope :orden_dep_dis, -> { order('nombre_departamento, nombre_distrito')}

  
  def uri_establecimiento
    "http://datos.mec.gov.py/id/establecimientos/#{self.codigo_establecimiento}"
  end
  
  def uri_institucion
    "http://datos.mec.gov.py/id/instituciones/#{self.codigo_institucion}"
  end
end
