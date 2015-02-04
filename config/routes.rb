Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  post "contactos_guardar" => "data#contactos_guardar", :as => :contactos_guardar
  post "contactos_lista" => "data#contactos_lista", :as => :contactos_lista
  get "contactos" => "data#contactos", :as => :contactos
  get "index" => "data#index", :as => :index
  get "about" => "data#about", :as => :about
  get "legal" => "data#legal", :as => :legal
  get "datos" => "data#datos", :as => :datos

  root 'data#index'
  
  get "application/autocompletar" => 'application#autocompletar', :as => :autocompletar

  post 'app/mapa_matriculaciones' => 'mapa_matriculaciones#index', :as => :app_mapa_matriculaciones2
  get 'app/mapa_matriculaciones' => 'mapa_matriculaciones#index', :as => :app_mapa_matriculaciones

  post "data/contrataciones_lista" => 'contrataciones#lista', :as => :data_contrataciones_lista
  get "data/contrataciones_lista" => 'contrataciones#lista', :as => :report_contrataciones_lista
  get 'data/contrataciones' => 'contrataciones#index', :as => :data_contrataciones
  get 'def/contrataciones' => 'contrataciones#diccionario', :as => :def_contrataciones

  post "data/nomina_administrativos_detalles" => 'nominas#detalles', :as => :data_nomina_administrativos_detalles
  post "data/nomina_administrativos_lista" => 'nominas#lista', :as => :data_nomina_administrativos_lista
  get "data/nomina_administrativos_lista" => 'nominas#lista', :as => :report_nomina_administrativos_lista
  get 'data/nomina_administrativos' => 'nominas#index', :as => :data_nomina_administrativos
  get 'def/nomina_administrativos' => 'nominas#diccionario', :as => :def_nomina_administrativos
  get "id/nomina_administrativos/:codigo_trabajador" => "nominas#administrativo_doc", :as => :id_nomimas_administrativo
  get "doc/nomina_administrativos/:codigo_trabajador" =>"nominas#administrativo_doc", :as => :doc_nomimas_administrativo

  post "data/nomina_docentes_detalles" => 'nominas#docentes_detalles', :as => :data_nomina_docentes_detalles
  post "data/nomina_docentes_lista" => 'nominas#docentes_lista', :as => :data_nomina_docentes_lista
  get "data/nomina_docentes_lista" => 'nominas#docentes_lista', :as => :report_nomina_docentes_lista
  get 'data/nomina_docentes' => 'nominas#docentes', :as => :data_nomina_docentes
  get 'def/nomina_docentes' => 'nominas#docentes_diccionario', :as => :def_nomina_docentes
  get "id/nomina_docentes/:codigo_trabajador" => "nominas#docentes_doc", :as => :id_nomimas_docentes
  get "doc/nomina_docentes/:codigo_trabajador" =>"nominas#docentes_doc", :as => :doc_nomimas_docentes

  get "data/matriculaciones_educacion_permanente_lista" => 'matriculaciones_educacion_permanente#lista', :as => :report_matriculaciones_educacion_permanente_lista
  post "data/matriculaciones_educacion_permanente_lista" => 'matriculaciones_educacion_permanente#lista', :as => :data_matriculaciones_educacion_permanente_lista
  get 'data/matriculaciones_educacion_permanente' => 'matriculaciones_educacion_permanente#index', :as => :data_matriculaciones_educacion_permanente
  get 'def/matriculaciones_educacion_permanente' => 'matriculaciones_educacion_permanente#diccionario', :as => :def_matriculaciones_educacion_permanente

  get "data/matriculaciones_educacion_inclusiva_lista" => 'matriculaciones_educacion_inclusiva#lista', :as => :report_matriculaciones_educacion_inclusiva_lista
  post "data/matriculaciones_educacion_inclusiva_lista" => 'matriculaciones_educacion_inclusiva#lista', :as => :data_matriculaciones_educacion_inclusiva_lista
  get 'data/matriculaciones_educacion_inclusiva' => 'matriculaciones_educacion_inclusiva#index', :as => :data_matriculaciones_educacion_inclusiva
  get 'def/matriculaciones_educacion_inclusiva' => 'matriculaciones_educacion_inclusiva#diccionario', :as => :def_matriculaciones_educacion_inclusiva

  post "data/matriculaciones_media_lista" => 'matriculaciones_media#lista', :as => :data_matriculaciones_media_lista
  get 'data/matriculaciones_media' => 'matriculaciones_media#index', :as => :data_matriculaciones_media
  get 'def/matriculaciones_media' => 'matriculaciones_media#diccionario', :as => :def_matriculaciones_media

  get "data/matriculaciones_inicial_lista" => 'matriculaciones_inicial#lista', :as => :report_matriculaciones_inicial_lista
  post "data/matriculaciones_inicial_lista" => 'matriculaciones_inicial#lista', :as => :data_matriculaciones_inicial_lista
  get 'data/matriculaciones_inicial' => 'matriculaciones_inicial#index', :as => :data_matriculaciones_inicial
  get 'def/matriculaciones_inicial' => 'matriculaciones_inicial#diccionario', :as => :def_matriculaciones_inicial

  get "data/matriculaciones_educacion_escolar_basica_lista" => 'matriculaciones_educacion_escolar_basica#lista', :as => :report_matriculaciones_educacion_escolar_basica_lista
  post "data/matriculaciones_educacion_escolar_basica_lista" => 'matriculaciones_educacion_escolar_basica#lista', :as => :data_matriculaciones_educacion_escolar_basica_lista
  get 'data/matriculaciones_educacion_escolar_basica' => 'matriculaciones_educacion_escolar_basica#index', :as => :data_matriculaciones_educacion_escolar_basica
  get 'def/matriculaciones_educacion_escolar_basica' => 'matriculaciones_educacion_escolar_basica#diccionario', :as => :def_matriculaciones_educacion_escolar_basica

  get "data/matriculaciones_departamentos_distritos_lista" => 'matriculaciones_departamentos_distritos#lista', :as => :report_matriculaciones_departamentos_distritos_lista
  post "data/matriculaciones_departamentos_distritos_lista" => 'matriculaciones_departamentos_distritos#lista', :as => :data_matriculaciones_departamentos_distritos_lista
  get 'data/matriculaciones_departamentos_distritos' => 'matriculaciones_departamentos_distritos#index', :as => :data_matriculaciones_departamentos_distritos
  get 'def/matriculaciones_departamentos_distritos' => 'matriculaciones_departamentos_distritos#diccionario', :as => :def_matriculaciones_departamentos_distritos

  get "data/matriculaciones_educacion_media_lista" => 'matriculaciones_educacion_media#lista', :as => :report_matriculaciones_educacion_media_lista
  post "data/matriculaciones_educacion_media_lista" => 'matriculaciones_educacion_media#lista', :as => :data_matriculaciones_educacion_media_lista
  get 'data/matriculaciones_educacion_media' => 'matriculaciones_educacion_media#index', :as => :data_matriculaciones_educacion_media
  get 'def/matriculaciones_educacion_media' => 'matriculaciones_educacion_media#diccionario', :as => :def_matriculaciones_educacion_media
  
  get "data/matriculaciones_educacion_superior_lista" => 'matriculaciones_educacion_superior#lista', :as => :report_matriculaciones_educacion_superior_lista
  post "data/matriculaciones_educacion_superior_lista" => 'matriculaciones_educacion_superior#lista', :as => :data_matriculaciones_educacion_superior_lista
  get 'data/matriculaciones_educacion_superior' => 'matriculaciones_educacion_superior#index', :as => :data_matriculaciones_educacion_superior
  get 'def/matriculaciones_educacion_superior' => 'matriculaciones_educacion_superior#diccionario', :as => :def_matriculaciones_educacion_superior
  
  get "data/instituciones_lista" => 'instituciones#lista', :as => :report_instituciones_lista
  post "data/instituciones_lista" => 'instituciones#lista', :as => :data_instituciones_lista
  get 'data/instituciones' => 'instituciones#index', :as => :data_instituciones
  get 'def/instituciones' => 'instituciones#diccionario', :as => :def_instituciones
  get "id/instituciones/:codigo_institucion" => "instituciones#doc", :as => :id_instituciones
  get "doc/instituciones/:codigo_institucion" => "instituciones#doc", :as => :doc_instituciones
  
  get "data/establecimientos_instituciones" => 'establecimientos#establecimientos_instituciones', :as => :data_establecimientos_instituciones
  post "data/establecimientos_ubicaciones_geograficas" => 'establecimientos#establecimientos_ubicaciones_geograficas', :as => :data_establecimientos_ubicaciones_geograficas
  post "data/establecimientos_ubicacion_geografica" => 'establecimientos#establecimientos_ubicacion_geografica', :as => :data_establecimientos_ubicacion_geografica  
  get "data/establecimientos_lista" => 'establecimientos#lista', :as => :report_establecimientos_lista
  post "data/establecimientos_lista" => 'establecimientos#lista', :as => :data_establecimientos_lista
  get 'data/establecimientos' => 'establecimientos#index', :as => :data_establecimientos
  get 'def/establecimientos' => 'establecimientos#diccionario', :as => :def_establecimientos
  get 'def/ejemplo_anio_cod_geo' => 'data#ejemplo_anio_cod_geo', :as => :def_ejemplo_anio_cod_geo  
  get "id/establecimientos/:codigo_establecimiento" => "establecimientos#establecimientos_doc", :as => :id_establecimientos
  get "doc/establecimientos/:codigo_establecimiento" => "establecimientos#establecimientos_doc", :as => :doc_establecimientos  
   
  get "data/establecimientos111_instituciones" => 'establecimientos111#instituciones', :as => :data_establecimientos111_instituciones
  post "data/establecimientos111_ubicaciones_geograficas" => 'establecimientos111#ubicaciones_geograficas', :as => :data_establecimientos111_ubicaciones_geograficas
  post "data/establecimientos111_ubicacion_geografica" => 'establecimientos111#ubicacion_geografica', :as => :data_establecimientos111_ubicacion_geografica
  get "data/establecimientos111_lista" => 'establecimientos111#lista', :as => :report_establecimientos111_lista
  post "data/establecimientos111_lista" => 'establecimientos111#lista', :as => :data_establecimientos111_lista
  get 'data/establecimientos111' => 'establecimientos111#index', :as => :data_establecimientos111
  get 'def/establecimientos111' => 'establecimientos111#diccionario', :as => :def_establecimientos111
  get "id/establecimientos111/:codigo_establecimiento" => "data#establecimientos111_doc", :as => :id_establecimientos111
  get "doc/establecimientos111/:codigo_establecimiento" => "data#establecimientos111_doc", :as => :doc_establecimientos111 

  get "data/establecimientos822_instituciones" => 'establecimientos822#instituciones', :as => :data_establecimientos822_instituciones
  post "data/establecimientos822_ubicaciones_geograficas" => 'establecimientos822#ubicaciones_geograficas', :as => :data_establecimientos822_ubicaciones_geograficas
  post "data/establecimientos822_ubicacion_geografica" => 'establecimientos822#ubicacion_geografica', :as => :data_establecimientos822_ubicacion_geografica
  get "data/establecimientos822_lista" => 'establecimientos822#lista', :as => :report_establecimientos822_lista
  post "data/establecimientos822_lista" => 'establecimientos822#lista', :as => :data_establecimientos822_lista
  get 'data/establecimientos822' => 'establecimientos822#index', :as => :data_establecimientos822
  get 'def/establecimientos822' => 'establecimientos822#diccionario', :as => :def_establecimientos822
  get "id/establecimientos822/:codigo_establecimiento" => "data#establecimientos822_doc", :as => :id_establecimientos822
  get "doc/establecimientos822/:codigo_establecimiento" => "data#establecimientos822_doc", :as => :doc_establecimientos822  
  
  get "data/establecimientos_escolares_priorizados_elegibles_fonacide" => 'requerimientos_infraestructuras#catalogo', :as => :data_requerimientos_infraestructuras_catalogo

  get 'app/academia/inventario_bienes_muebles' => 'visualizaciones#academia_inventario_bienes_muebles', :as => :app_academia_inventario_bienes_muebles
  get 'app/academia/inventario_bienes_inmuebles' => 'visualizaciones#academia_inventario_bienes_inmuebles', :as => :app_academia_inventario_bienes_inmuebles
  get 'app/academia/inventario_bienes_rodados' => 'visualizaciones#academia_inventario_bienes_rodados', :as => :app_academia_inventario_bienes_rodados
  get 'app/academia/funcionarios_administrativos' => 'visualizaciones#academia_funcionarios_administrativos', :as => :app_academia_funcionarios_administrativos
  get 'app/academia/funcionarios_docentes' => 'visualizaciones#academia_funcionarios_docentes', :as => :app_academia_funcionarios_docentes
  get "data/visualizaciones" => 'visualizaciones#index', :as => :data_visualizaciones

  post "data/directorios_instituciones_lista" => 'directorios_instituciones#lista', :as => :data_directorios_instituciones_lista
  get "data/directorios_instituciones_lista" => 'directorios_instituciones#lista', :as => :report_directorios_instituciones_lista
  get 'data/directorios_instituciones' => 'directorios_instituciones#index', :as => :data_directorios_instituciones
  get 'def/directorios_instituciones' => 'directorios_instituciones#diccionario', :as => :def_directorios_instituciones
  
  post "data/requerimientos_aulas_lista" => 'requerimientos_aulas#lista', :as => :data_requerimientos_aulas_lista
  get "data/requerimientos_aulas_lista" => 'requerimientos_aulas#lista', :as => :report_requerimientos_aulas_lista
  get 'data/requerimientos_aulas' => 'requerimientos_aulas#index', :as => :data_requerimientos_aulas
  get 'def/requerimientos_aulas' => 'requerimientos_aulas#diccionario', :as => :def_requerimientos_aulas
  
  post "data/requerimientos_sanitarios_lista" => 'requerimientos_sanitarios#lista', :as => :data_requerimientos_sanitarios_lista
  get "data/requerimientos_sanitarios_lista" => 'requerimientos_sanitarios#lista', :as => :report_requerimientos_sanitarios_lista
  get 'data/requerimientos_sanitarios' => 'requerimientos_sanitarios#index', :as => :data_requerimientos_sanitarios
  get 'def/requerimientos_sanitarios' => 'requerimientos_sanitarios#diccionario', :as => :def_requerimientos_sanitarios
  
  post "data/requerimientos_mobiliarios_lista" => 'requerimientos_mobiliarios#lista', :as => :data_requerimientos_mobiliarios_lista
  get "data/requerimientos_mobiliarios_lista" => 'requerimientos_mobiliarios#lista', :as => :report_requerimientos_mobiliarios_lista
  get 'data/requerimientos_mobiliarios' => 'requerimientos_mobiliarios#index', :as => :data_requerimientos_mobiliarios
  get 'def/requerimientos_mobiliarios' => 'requerimientos_mobiliarios#diccionario', :as => :def_requerimientos_mobiliarios
  
  post "data/requerimientos_otros_espacios_lista" => 'requerimientos_otros_espacios#lista', :as => :data_requerimientos_otros_espacios_lista
  get "data/requerimientos_otros_espacios_lista" => 'requerimientos_otros_espacios#lista', :as => :report_requerimientos_otros_espacios_lista
  get 'data/requerimientos_otros_espacios' => 'requerimientos_otros_espacios#index', :as => :data_requerimientos_otros_espacios
  get 'def/requerimientos_otros_espacios' => 'requerimientos_otros_espacios#diccionario', :as => :def_requerimientos_otros_espacios
  
  post "data/requerimientos_alimentacion_lista" => 'requerimientos_alimentacion#lista', :as => :data_requerimientos_alimentacion_lista
  get "data/requerimientos_alimentacion_lista" => 'requerimientos_alimentacion#lista', :as => :report_requerimientos_alimentacion_lista
  get 'data/requerimientos_alimentacion' => 'requerimientos_alimentacion#index', :as => :data_requerimientos_alimentacion
  get 'def/requerimientos_alimentacion' => 'requerimientos_alimentacion#diccionario', :as => :def_requerimientos_alimentacion
  
  post "data/servicios_basicos_lista" => 'servicios_basicos#lista', :as => :data_servicios_basicos_lista
  get "data/servicios_basicos_lista" => 'servicios_basicos#lista', :as => :report_servicios_basicos_lista
  get 'data/servicios_basicos' => 'servicios_basicos#index', :as => :data_servicios_basicos
  get 'def/servicios_basicos' => 'servicios_basicos#diccionario', :as => :def_servicios_basicos

  post "data/registros_titulos_lista" => 'registros_titulos#lista', :as => :data_registros_titulos_lista
  get "data/registros_titulos_lista" => 'registros_titulos#lista', :as => :report_registros_titulos_lista
  get 'data/registros_titulos' => 'registros_titulos#index', :as => :data_registros_titulos
  get 'def/registros_titulos' => 'registros_titulos#diccionario', :as => :def_registros_titulos

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
