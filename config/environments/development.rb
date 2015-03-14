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

  config.assets.precompile += %w( mapa_matriculaciones.css leaflet.css slider.css bootstrap-slider.js ie10-viewport-bug-workaround.js leaflet.js mapa_matriculaciones.js matriculados.js views/datos_ver_view.js views/datos_view.js views/index_view.js views/visualizaciones_view.js views/uri_establecimiento_view.js views/uri_institucion_view.js views/uri_nomina_view.js mapbox.css mapbox.js mapa/spin.js mapa/select2.min.js mapa/config.js mapa/viviendas.js mapa/Google.js mapa/leaflet.markercluster.js mapa/sprintf.min.js mapa/imgs.js mapa/jquery.flexslider-min.js mapa/geojson.min.js mapa/select2.min.css mapa/MarkerCluster.css mapa/MarkerCluster.Default.css mapa/flexslider.css bower_components/angular/angular.js bower_components/bootstrap/dist/js/bootstrap.js bower_components/angular-route/angular-route.js bower_components/angular-bootstrap/ui-bootstrap-tpls.js bower_components/d3/d3.js bower_components/underscore/underscore.js bower_components/tide-angular/tide-angular.js scripts/app.js scripts/controllers/nivelFormacion.js scripts/services/nivelFormacionDataService.js scripts/controllers/tide-angular-levelPiramid/tide-angular-levelPiramid.js bower_components/jquery/dist/jquery.js scripts/controllers/tide-angular-percentile-bar/tide-angular-percentile-bar.js scripts/controllers/formacionCompatibleController.js scripts/controllers/tituloCompatibleController.js scripts/directives/tide-angular-bubbles/tide-angular-bubbles.js)


  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
