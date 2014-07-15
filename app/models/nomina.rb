class Nomina < ActiveRecord::Base

  self.table_name = "nomina"

  scope :ordenado_anio_mes_nombre, :order => 'ano_periodo_pago, mes_periodo_pago, nombre_trabajador'

  scope :es_docente, where('es_categoria_administrativa = 0')
  scope :es_administrativo, where('es_categoria_administrativa = 1')

end
