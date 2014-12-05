class VEstadoLocal < ActiveRecord::Base

  acts_as_xlsx

  scope :orden_dep_dis, :order => 'nombre_departamento, nombre_distrito'

end
