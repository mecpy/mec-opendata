class Contratacion < ActiveRecord::Base

  #establish_connection "mec_production"
  self.table_name='contrataciones'

  acts_as_xlsx

end
