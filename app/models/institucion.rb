class Institucion < ActiveRecord::Base

  scope :orden_dep_dis, -> { order('nombre_departamento, nombre_distrito')}

end
