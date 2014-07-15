OpenData::Application.routes.draw do

  match "data/nomina_administrativos_detalles" => 'nominas#detalles', :as => :data_nomina_administrativos_detalles
  match "data/nomina_administrativos_lista" => 'nominas#lista', :as => :data_nomina_administrativos_lista
  match 'data/nomina_administrativos' => 'nominas#index', :as => :data_nomina_administrativos
  match 'def/nomina_administrativos' => 'nominas#diccionario', :as => :def_nomina_administrativos

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

  match "data/instituciones_lista" => 'instituciones#lista', :as => :data_instituciones_lista
  match 'data/instituciones' => 'instituciones#index', :as => :data_instituciones
  match 'def/instituciones' => 'instituciones#diccionario', :as => :def_instituciones

  match "data/establecimientos_instituciones", :as => :data_establecimientos_instituciones
  match "data/establecimientos_ubicaciones_geograficas", :as => :data_establecimientos_ubicaciones_geograficas
  match "data/establecimientos_ubicacion_geografica", :as => :data_establecimientos_ubicacion_geografica
  match "data/establecimientos_lista", :as => :data_establecimientos_lista
  match 'data/establecimientos' => 'data#establecimientos', :as => :data_establecimientos
  match 'def/establecimientos' => 'data#diccionario_establecimientos', :as => :def_establecimientos

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
