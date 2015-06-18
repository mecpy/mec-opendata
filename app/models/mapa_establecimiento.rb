class MapaEstablecimiento < ActiveRecord::Base

  self.table_name = 'v_mapa_centroide'

  scope :orden_dep_dis, -> { order('nombre_departamento, nombre_distrito')}
  
end