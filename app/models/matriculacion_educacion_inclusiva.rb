class MatriculacionEducacionInclusiva < ActiveRecord::Base

  set_table_name "matriculaciones_educacion_inclusiva"
  
  acts_as_xlsx 

  scope :orden_dep_dis, :order => 'nombre_departamento, nombre_distrito'
  
  scope :filtrar_por_codigo_institucion_and_codigo_establecimiento, lambda { |codigo_institucion, codigo_establecimiento| where(:codigo_institucion => codigo_institucion, :codigo_establecimiento => codigo_establecimiento) }

end
