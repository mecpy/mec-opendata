class MatriculacionEducacionMedia < ActiveRecord::Base
    
  self.table_name = 'matriculaciones_media'

  scope :ordenado_institucion, -> { order('nombre_departamento, nombre_distrito, nombre_institucion')}
 
  scope :filtrar_por_codigo_institucion_and_codigo_establecimiento, lambda { |codigo_institucion, codigo_establecimiento| where(:codigo_institucion => codigo_institucion, :codigo_establecimiento => codigo_establecimiento) }

  scope :filtrar_por_anio, lambda { |anio| where(:anio => anio) }

end
