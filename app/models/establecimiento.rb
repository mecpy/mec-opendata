class Establecimiento < ActiveRecord::Base

  acts_as_xlsx 

  scope :orden_dep_dis, :order => 'nombre_departamento, nombre_distrito'

  def uri
    "http://datos.mec.gov.py/id/establecimientos/#{self.codigo_establecimiento}"
  end

  def codigo_establecimiento_
    "#{self.codigo_establecimiento} "
  end

end
