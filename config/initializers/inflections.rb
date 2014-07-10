# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
#
# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.acronym 'RESTful'
# end

ActiveSupport::Inflector.inflections do |inflect|
   inflect.plural(/([aeiou])([A-Z]|_|$)/, '\1s\2')
   inflect.plural(/([rlnsd])([A-Z]|_|$)/, '\1es\2')
   inflect.plural(/([aeiou])([A-Z]|_|$)([a-z]+)([rlnd])($)/, '\1s\2\3\4es\5')
   inflect.plural(/([rlnd])([A-Z]|_|$)([a-z]+)([aeiou])($)/, '\1es\2\3\4s\5')
   inflect.singular(/([aeiou])s([A-Z]|_|$)/, '\1\2')
   inflect.singular(/([rlnsd])es([A-Z]|_|$)/, '\1\2')
   inflect.singular(/([aeiou])s([A-Z]|_)([a-z]+)([rlnd])es($)/, '\1\2\3\4\5')
   inflect.singular(/([rlnsd])es([A-Z]|_)([a-z]+)([aeiou])s($)/, '\1\2\3\4\5')
   inflect.irregular 'tipo_combustible', 'tipos_combustibles'
   inflect.irregular 'condicion_solicitud', 'condiciones_solicitudes'
   inflect.irregular 'catalogo_detalle', 'catalogos_detalles'
   inflect.irregular 'especificacion_detalle', 'especificaciones_detalles'
   inflect.irregular 'solicitud_detalle', 'solicitudes_detalles'
   inflect.irregular 'presupuesto_detalle', 'presupuestos_detalles'
   inflect.irregular 'solicitud_producto_detalle', 'solicitudes_productos_detalles'
   inflect.irregular 'legajo_detalle', 'legajos_detalles'
   inflect.irregular 'paquete_detalle', 'paquetes_detalles'

end
