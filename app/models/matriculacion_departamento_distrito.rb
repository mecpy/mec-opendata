class MatriculacionDepartamentoDistrito < ActiveRecord::Base
  
  self.table_name = 'matriculaciones_departamentos_distritos'

  scope :orden_dep_dis, -> { order('nombre_departamento, nombre_distrito')}

end
