=begin
@author Rodrigo Parra
@copyright 2014 Governance and Democracy Program USAID-CEAMSO
@license http://www.gnu.org/licenses/gpl-2.0.html

USAID-CEAMSO
Copyright (C) 2014 Governance and Democracy Program
http://ceamso.org.py/es/proyectos/20-programa-de-democracia-y-gobernabilidad

--------------------------------------------------------------------------
This file is part of the Governance and Democracy Program USAID-CEAMSO,
is distributed as free software in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. You can redistribute it and/or modify it under the
terms of the GNU Lesser General Public License version 2 as published by the
Free Software Foundation, accessible from <http://www.gnu.org/licenses/> or write
to Free Software Foundation (FSF) Inc., 51 Franklin St, Fifth Floor, Boston,
MA 02111-1301, USA.
-------------------------------------------------------------------------
Este archivo es parte del Programa de Democracia y Gobernabilidad USAID-CEAMSO,
es distribuido como software libre con la esperanza que sea de utilidad,
pero sin NINGUNA GARANTÍA; sin garantía alguna implícita de ADECUACION a cualquier
MERCADO o APLICACION EN PARTICULAR. Usted puede redistribuirlo y/o modificarlo
bajo los términos de la GNU Lesser General Public Licence versión 2 de la Free
Software Foundation, accesible en <http://www.gnu.org/licenses/> o escriba a la
Free Software Foundation (FSF) Inc., 51 Franklin St, Fifth Floor, Boston,
MA 02111-1301, USA.
=end



class MapaEstablecimientosController < ApplicationController
  
  before_action :set_headers

  skip_before_filter :verify_authenticity_token, :only => [:datos]

  def index
    
    respond_to do |format|
      format.html {
        if params[:embedded].present? and params[:embedded] == 'true'
          render :layout => 'application_embedded'
        else
          render :layout => 'application_mapa_establecimientos'
        end
      }
    end

  end

  def datos
    
    beginning_time = Time.now

    condicion=[]
    query=''
    msg=''

    requiere_consulta = [ "12" ]

    if params[:tipo_consulta].present?
        
      if params[:tipo_consulta]=='01' # tipo_consulta:01 -> centroide de los departamentos
        
        results = File.read("#{Rails.root}/app/assets/javascripts/geometrias/topojson_departamentos.json")
      
      elsif params[:tipo_consulta]=='02' # tipo_consulta:02 -> centroide de los distritos
        
        results = File.read("#{Rails.root}/app/assets/javascripts/geometrias/topojson_distritos.json")
      
      elsif params[:tipo_consulta]=='03' # tipo_consulta:03 -> centroide de los barrio/localidad
        
        results = File.read("#{Rails.root}/app/assets/javascripts/geometrias/topojson_barrio_localidad.json")

      elsif params[:tipo_consulta]=='11' # tipo_consulta:11 -> establecimientos

        results = File.read("#{Rails.root}/app/assets/javascripts/geometrias/topojson_establecimientos_2014.json")

      elsif params[:tipo_consulta]=='12' # tipo_consulta:12 -> instituciones

        if params[:establecimientos].present? and params[:periodo].present?
          establecimientos=params[:establecimientos]
          condicion = "vdi.periodo = " +  params[:periodo] + " AND vdi.codigo_establecimiento = ANY(array" + establecimientos.to_s.gsub("\"", "'") + ")"
          query = "SELECT vdi.nombre_departamento, vdi.nombre_distrito, vdi.nombre_barrio_localidad,
                  vdi.codigo_institucion, vdi.nombre_institucion, vdi.codigo_establecimiento
                  FROM v_directorios_instituciones vdi
                  WHERE " + condicion + " ORDER BY nombre_departamento ASC, nombre_distrito ASC, nombre_barrio_localidad ASC"
        else
          puts 'Parámetros incorrectos'
        end
      
      end

      #beginning_time = Time.now
      #end_time = Time.now
      #puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"

      if requiere_consulta.include? params[:tipo_consulta]
        results = ActiveRecord::Base.connection.execute(query)
      end
      
      render :json => results
      end_time = Time.now
      puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"

    end

  end

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
  
end