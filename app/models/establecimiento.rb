class Establecimiento < ActiveRecord::Base

  self.table_name = 'establecimientos'

  scope :orden_dep_dis, -> { order('nombre_departamento, nombre_distrito')}
  scope :por_primera_infancia, -> { where("codigo_establecimiento in (?) and anio = 2014", PARAMETRO[:establecimientos_primera_infancia] )}

  def uri
    "http://datos.mec.gov.py/id/establecimientos/#{self.codigo_establecimiento}"
  end
  
end
