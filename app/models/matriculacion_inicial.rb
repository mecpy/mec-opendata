class MatriculacionInicial < ActiveRecord::Base

  set_table_name "matriculaciones_inicial"
  acts_as_xlsx 
  scope :ordenado_institucion, :order => 'nombre_departamento, nombre_distrito, nombre_institucion'
  scope :filtrar_por_codigo_institucion_and_codigo_establecimiento, lambda { |codigo_institucion, codigo_establecimiento| where(:codigo_institucion => codigo_institucion, :codigo_establecimiento => codigo_establecimiento) }
end
