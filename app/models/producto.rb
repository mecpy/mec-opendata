class Producto < ActiveRecord::Base

  self.table_name='productos'
  self.primary_key='producto_id'

  def uri_producto
    "http://datos.mec.gov.py/id/productos/#{self.producto_codigo}"
  end

  def fecha_corte
    "2015-09-14"
  end

end
