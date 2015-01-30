Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.assets.precompile += %w( mapa_matriculaciones.css leaflet.css slider.css bootstrap-slider.js ie10-viewport-bug-workaround.js leaflet.js mapa_matriculaciones.js matriculados.js diccionario/requerimientos_aulas.js diccionario/requerimientos_mobiliarios.js diccionario/requerimientos_otros_espacios.js diccionario/requerimientos_sanitarios.js diccionario/servicios_basicos.js diccionario/instituciones.js diccionario/directorios_instituciones.js diccionario/establecimientos.js diccionario/establecimientos822.js diccionario/establecimientos111.js diccionario/contrataciones.js diccionario/registros_titulos.js diccionario/nomina_administrativos.js diccionario/nomina_docentes.js diccionario/matriculaciones_departamentos_distritos.js diccionario/matriculaciones_educacion_escolar_basica.js diccionario/matriculaciones_educacion_inclusiva.js diccionario/matriculaciones_educacion_media.js diccionario/matriculaciones_educacion_permanente.js diccionario/matriculaciones_educacion_superior.js diccionario/matriculaciones_inicial.js)

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
