class Contratacion < ActiveRecord::Base

  establish_connection "mec_production"
  self.table_name='v_llamado_detalle'

  acts_as_xlsx

end
