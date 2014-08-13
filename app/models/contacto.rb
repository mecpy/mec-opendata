class Contacto < ActiveRecord::Base

  attr_accessible :nombre, :apellido, :email, :asunto, :categoria_contacto_id, :mensaje 

  scope :ordenado_fecha_desc, :order => "fecha desc, hora desc"

end
