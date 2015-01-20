OpenData::Application.routes.draw do

  match "data/establecimientos_escolares_priorizados_elegibles_fonacide" => 'requerimientos_infraestructuras#catalogo', :as => :data_requerimientos_infraestructuras_catalogo

  match 'app/academia/inventario_bienes_muebles' => 'visualizaciones#academia_inventario_bienes_muebles', :as => :app_academia_inventario_bienes_muebles
  match 'app/academia/inventario_bienes_inmuebles' => 'visualizaciones#academia_inventario_bienes_inmuebles', :as => :app_academia_inventario_bienes_inmuebles
  match 'app/academia/inventario_bienes_rodados' => 'visualizaciones#academia_inventario_bienes_rodados', :as => :app_academia_inventario_bienes_rodados
  match 'app/academia/funcionarios_administrativos' => 'visualizaciones#academia_funcionarios_administrativos', :as => :app_academia_funcionarios_administrativos
  match 'app/academia/funcionarios_docentes' => 'visualizaciones#academia_funcionarios_docentes', :as => :app_academia_funcionarios_docentes
  match "data/visualizaciones" => 'visualizaciones#index', :as => :data_visualizaciones
  
  match "data/registros_titulos_lista" => 'registros_titulos#lista', :as => :data_registros_titulos_lista
  match 'data/registros_titulos' => 'registros_titulos#index', :as => :data_registros_titulos
  match 'def/registros_titulos' => 'registros_titulos#diccionario', :as => :def_registros_titulos

  match 'app/mapa_matriculaciones' => 'mapa_matriculaciones#index', :as => :app_mapa_matriculaciones

  match "data/contrataciones_lista" => 'contrataciones#lista', :as => :data_contrataciones_lista
  match 'data/contrataciones' => 'contrataciones#index', :as => :data_contrataciones
  match 'def/contrataciones' => 'contrataciones#diccionario', :as => :def_contrataciones

  match "id/nomina_administrativos/:codigo_trabajador" => "nominas#administrativo_doc", :as => :id_nomimas_administrativo
  match "doc/nomina_administrativos/:codigo_trabajador" =>"nominas#administrativo_doc", :as => :doc_nomimas_administrativo
  match "data/nomina_administrativos_detalles" => 'nominas#detalles', :as => :data_nomina_administrativos_detalles
  match "data/nomina_administrativos_lista" => 'nominas#lista', :as => :data_nomina_administrativos_lista
  match 'data/nomina_administrativos' => 'nominas#index', :as => :data_nomina_administrativos
  match 'def/nomina_administrativos' => 'nominas#diccionario', :as => :def_nomina_administrativos
  match "id/nomina_docentes/:codigo_trabajador" => "nominas#docentes_doc", :as => :id_nomimas_docentes
  match "doc/nomina_docentes/:codigo_trabajador" =>"nominas#docentes_doc", :as => :doc_nomimas_docentes
  match "data/nomina_docentes_detalles" => 'nominas#docentes_detalles', :as => :data_nomina_docentes_detalles
  match "data/nomina_docentes_lista" => 'nominas#docentes_lista', :as => :data_nomina_docentes_lista
  match 'data/nomina_docentes' => 'nominas#docentes', :as => :data_nomina_docentes
  match 'def/nomina_docentes' => 'nominas#docentes_diccionario', :as => :def_nomina_docentes

  match "data/matriculaciones_educacion_permanente_lista" => 'matriculaciones_educacion_permanente#lista', :as => :data_matriculaciones_educacion_permanente_lista
  match 'data/matriculaciones_educacion_permanente' => 'matriculaciones_educacion_permanente#index', :as => :data_matriculaciones_educacion_permanente
  match 'def/matriculaciones_educacion_permanente' => 'matriculaciones_educacion_permanente#diccionario', :as => :def_matriculaciones_educacion_permanente

  match "data/matriculaciones_educacion_inclusiva_lista" => 'matriculaciones_educacion_inclusiva#lista', :as => :data_matriculaciones_educacion_inclusiva_lista
  match 'data/matriculaciones_educacion_inclusiva' => 'matriculaciones_educacion_inclusiva#index', :as => :data_matriculaciones_educacion_inclusiva
  match 'def/matriculaciones_educacion_inclusiva' => 'matriculaciones_educacion_inclusiva#diccionario', :as => :def_matriculaciones_educacion_inclusiva


  match "data/matriculaciones_media_lista" => 'matriculaciones_media#lista', :as => :data_matriculaciones_media_lista
  match 'data/matriculaciones_media' => 'matriculaciones_media#index', :as => :data_matriculaciones_media
  match 'def/matriculaciones_media' => 'matriculaciones_media#diccionario', :as => :def_matriculaciones_media

  match "data/matriculaciones_inicial_lista" => 'matriculaciones_inicial#lista', :as => :data_matriculaciones_inicial_lista
  match 'data/matriculaciones_inicial' => 'matriculaciones_inicial#index', :as => :data_matriculaciones_inicial
  match 'def/matriculaciones_inicial' => 'matriculaciones_inicial#diccionario', :as => :def_matriculaciones_inicial

  match "data/matriculaciones_educacion_escolar_basica_lista" => 'matriculaciones_educacion_escolar_basica#lista', :as => :data_matriculaciones_educacion_escolar_basica_lista
  match 'data/matriculaciones_educacion_escolar_basica' => 'matriculaciones_educacion_escolar_basica#index', :as => :data_matriculaciones_educacion_escolar_basica
  match 'def/matriculaciones_educacion_escolar_basica' => 'matriculaciones_educacion_escolar_basica#diccionario', :as => :def_matriculaciones_educacion_escolar_basica

  match "data/matriculaciones_departamentos_distritos_lista" => 'matriculaciones_departamentos_distritos#lista', :as => :data_matriculaciones_departamentos_distritos_lista
  match 'data/matriculaciones_departamentos_distritos' => 'matriculaciones_departamentos_distritos#index', :as => :data_matriculaciones_departamentos_distritos
  match 'def/matriculaciones_departamentos_distritos' => 'matriculaciones_departamentos_distritos#diccionario', :as => :def_matriculaciones_departamentos_distritos

  match "data/matriculaciones_educacion_media_lista" => 'matriculaciones_educacion_media#lista', :as => :data_matriculaciones_educacion_media_lista
  match 'data/matriculaciones_educacion_media' => 'matriculaciones_educacion_media#index', :as => :data_matriculaciones_educacion_media
  match 'def/matriculaciones_educacion_media' => 'matriculaciones_educacion_media#diccionario', :as => :def_matriculaciones_educacion_media
  
  match "data/matriculaciones_educacion_superior_lista" => 'matriculaciones_educacion_superior#lista', :as => :data_matriculaciones_educacion_superior_lista
  match 'data/matriculaciones_educacion_superior' => 'matriculaciones_educacion_superior#index', :as => :data_matriculaciones_educacion_superior
  match 'def/matriculaciones_educacion_superior' => 'matriculaciones_educacion_superior#diccionario', :as => :def_matriculaciones_educacion_superior

  match "id/instituciones/:codigo_institucion" => "instituciones#doc", :as => :id_instituciones
  match "doc/instituciones/:codigo_institucion" => "instituciones#doc", :as => :doc_instituciones
  match "data/instituciones_lista" => 'instituciones#lista', :as => :data_instituciones_lista
  match 'data/instituciones' => 'instituciones#index', :as => :data_instituciones
  match 'def/instituciones' => 'instituciones#diccionario', :as => :def_instituciones
  
=begin
  match "id/directorios_instituciones/:codigo_institucion" => "directorios_instituciones#doc", :as => :id_instituciones
  match "doc/directorios_instituciones/:codigo_institucion" => "directorios_instituciones#doc", :as => :doc_directorios_instituciones
=end
  match "data/directorios_instituciones_lista" => 'directorios_instituciones#lista', :as => :data_directorios_instituciones_lista
  match 'data/directorios_instituciones' => 'directorios_instituciones#index', :as => :data_directorios_instituciones
  match 'def/directorios_instituciones' => 'directorios_instituciones#diccionario', :as => :def_directorios_instituciones
  
  match "data/requerimientos_aulas_lista" => 'requerimientos_aulas#lista', :as => :data_requerimientos_aulas_lista
  match 'data/requerimientos_aulas' => 'requerimientos_aulas#index', :as => :data_requerimientos_aulas
  match 'def/requerimientos_aulas' => 'requerimientos_aulas#diccionario', :as => :def_requerimientos_aulas
  
  match "data/requerimientos_sanitarios_lista" => 'requerimientos_sanitarios#lista', :as => :data_requerimientos_sanitarios_lista
  match 'data/requerimientos_sanitarios' => 'requerimientos_sanitarios#index', :as => :data_requerimientos_sanitarios
  match 'def/requerimientos_sanitarios' => 'requerimientos_sanitarios#diccionario', :as => :def_requerimientos_sanitarios
  
  match "data/requerimientos_mobiliarios_lista" => 'requerimientos_mobiliarios#lista', :as => :data_requerimientos_mobiliarios_lista
  match 'data/requerimientos_mobiliarios' => 'requerimientos_mobiliarios#index', :as => :data_requerimientos_mobiliarios
  match 'def/requerimientos_mobiliarios' => 'requerimientos_mobiliarios#diccionario', :as => :def_requerimientos_mobiliarios
  
  match "data/requerimientos_otros_espacios_lista" => 'requerimientos_otros_espacios#lista', :as => :data_requerimientos_otros_espacios_lista
  match 'data/requerimientos_otros_espacios' => 'requerimientos_otros_espacios#index', :as => :data_requerimientos_otros_espacios
  match 'def/requerimientos_otros_espacios' => 'requerimientos_otros_espacios#diccionario', :as => :def_requerimientos_otros_espacios
  
  match "data/requerimientos_alimentacion_lista" => 'requerimientos_alimentacion#lista', :as => :data_requerimientos_alimentacion_lista
  match 'data/requerimientos_alimentacion' => 'requerimientos_alimentacion#index', :as => :data_requerimientos_alimentacion
  match 'def/requerimientos_alimentacion' => 'requerimientos_alimentacion#diccionario', :as => :def_requerimientos_alimentacion
  
  match "data/servicios_basicos_lista" => 'servicios_basicos#lista', :as => :data_servicios_basicos_lista
  match 'data/servicios_basicos' => 'servicios_basicos#index', :as => :data_servicios_basicos
  match 'def/servicios_basicos' => 'servicios_basicos#diccionario', :as => :def_servicios_basicos

  match "id/establecimientos/:codigo_establecimiento" => "data#establecimientos_doc", :as => :id_establecimientos
  match "doc/establecimientos/:codigo_establecimiento" => "data#establecimientos_doc", :as => :doc_establecimientos  
  match "data/establecimientos_instituciones", :as => :data_establecimientos_instituciones
  match "data/establecimientos_ubicaciones_geograficas", :as => :data_establecimientos_ubicaciones_geograficas
  match "data/establecimientos_ubicacion_geografica", :as => :data_establecimientos_ubicacion_geografica
  match "data/establecimientos_lista", :as => :data_establecimientos_lista
  match 'data/establecimientos' => 'data#establecimientos', :as => :data_establecimientos
  match 'def/establecimientos' => 'data#diccionario_establecimientos', :as => :def_establecimientos
  match 'def/ejemplo_anio_cod_geo' => 'data#ejemplo_anio_cod_geo', :as => :def_ejemplo_anio_cod_geo

  match "id/establecimientos111/:codigo_establecimiento" => "data#establecimientos111_doc", :as => :id_establecimientos111
  match "doc/establecimientos111/:codigo_establecimiento" => "data#establecimientos111_doc", :as => :doc_establecimientos111  
  match "data/establecimientos111_instituciones", :as => :data_establecimientos111_instituciones
  match "data/establecimientos111_ubicaciones_geograficas", :as => :data_establecimientos111_ubicaciones_geograficas
  match "data/establecimientos111_ubicacion_geografica", :as => :data_establecimientos111_ubicacion_geografica
  match "data/establecimientos111_lista" => 'establecimientos111#lista', :as => :data_establecimientos111_lista
  match 'data/establecimientos111' => 'establecimientos111#index', :as => :data_establecimientos111
  match 'def/establecimientos111' => 'establecimientos111#diccionario', :as => :def_establecimientos111


  match "contactos_guardar" => "data#contactos_guardar", :as => :contactos_guardar
  match "contactos_lista" => "data#contactos_lista", :as => :contactos_lista
  match "contactos" => "data#contactos", :as => :contactos
  match "index" => "data#index", :as => :index
  match "about" => "data#about", :as => :about
  match "legal" => "data#legal", :as => :legal

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'data#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
