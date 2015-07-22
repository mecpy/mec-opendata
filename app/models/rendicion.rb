class Rendicion < ActiveRecord::Base
  scope :ordenado_periodo_orden_nivel, -> { order('periodo, orden, nivel')}
end
