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

    condicion=[]
    query=''
    msg=''

    if params[:tipo].present?
        
      if params[:tipo]=='01' # tipo:01 -> centroide de los departamentos
        
        condicion = "(COALESCE(nombre_barrio_localidad, '') = '') AND (COALESCE(nombre_distrito, '') = '') AND (NOT (COALESCE(nombre_departamento, '') = ''))"
        query = "SELECT row_to_json(egeojson) As e_geojson
                FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
                FROM (SELECT 'Feature' As type
                , ST_AsGeoJSON(vmc.geom)::json As geometry
                , row_to_json((SELECT l FROM (SELECT vmc.nombre_departamento As nombre_departamento) As l)) As properties
                FROM v_mapa_centroide As vmc WHERE " + condicion + ") As f) As egeojson"
      
      elsif params[:tipo]=='02' # tipo:02 -> centroide de los distritos
        
        condicion = "(COALESCE(nombre_barrio_localidad, '') = '') AND (NOT (COALESCE(nombre_distrito, '') = '')) AND (NOT (COALESCE(nombre_departamento, '') = ''))"
        query = "SELECT row_to_json(egeojson) As e_geojson
                FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
                FROM (SELECT 'Feature' As type
                , ST_AsGeoJSON(vmc.geom)::json As geometry
                , row_to_json((SELECT l FROM (SELECT vmc.nombre_departamento As nombre_departamento, vmc.nombre_distrito As nombre_distrito) As l)) As properties
                FROM v_mapa_centroide As vmc WHERE " + condicion + ") As f) As egeojson"
      
      elsif params[:tipo]=='03' # tipo:03 -> centroide de los barrio/localidad
        
        condicion = "((NOT COALESCE(nombre_barrio_localidad, '') = '')) AND (NOT (COALESCE(nombre_distrito, '') = '')) AND (NOT (COALESCE(nombre_departamento, '') = ''))"
        query = "SELECT row_to_json(egeojson) As e_geojson
                FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
                FROM (SELECT 'Feature' As type
                , ST_AsGeoJSON(vmc.geom)::json As geometry
                , row_to_json((SELECT l FROM (SELECT vmc.nombre_departamento As nombre_departamento, vmc.nombre_distrito As nombre_distrito,
                  vmc.nombre_barrio_localidad As nombre_barrio_localidad) As l)) As properties
                FROM v_mapa_centroide As vmc WHERE " + condicion + ") As f) As egeojson"

      elsif params[:tipo]=='11' # tipo:11 -> establecimientos

        query = "SELECT row_to_json(egeojson) As e_geojson
                FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
                FROM (SELECT 'Feature' As type
                , ST_AsGeoJSON(ST_SetSRID(ST_MakePoint(round(dms2dd(es.longitud),10), round(dms2dd(es.latitud),10)),0))::json As geometry
                , row_to_json((SELECT l FROM (SELECT es.anio::text As periodo, es.codigo_establecimiento As codigo_establecimiento, 
                  es.nombre_departamento As nombre_departamento, es.nombre_distrito As nombre_distrito, es.nombre_barrio_localidad As nombre_barrio_localidad,
                  es.nombre_zona As nombre_zona, es.proyecto_111 As proyecto111, es.proyecto_822 As proyecto822) As l)) As properties
                FROM establecimientos As es WHERE es.anio=2014 AND (NOT es.longitud='') AND (NOT es.latitud='') limit 100 ) 
                As f) As egeojson"
      
      elsif params[:tipo]=='12' # tipo:12 -> instituciones
        
        if params[:establecimientos].present?
          #establecimientos = ActiveSupport::JSON.decode(params[:establecimientos])
          establecimientos=params[:establecimientos]
          #condicion = "periodo = " +  2014.to_s + "codigo_establecimiento = ANY (" + establecimientos + ")"
          condicion = "vdi.periodo = " +  2014.to_s + " AND vdi.codigo_departamento = '06'" + " AND vdi.codigo_establecimiento = ANY('" + establecimientos + "')"
          query = "SELECT DISTINCT ON(vdi.codigo_establecimiento) codigo_establecimiento, vdi.nombre_departamento, vdi.nombre_distrito, vdi.nombre_barrio_localidad,
                  (SELECT array_to_json(array_agg(row_to_json(t)))
                  FROM ( 
                    SELECT di.codigo_institucion, di.nombre_institucion 
                    FROM v_directorios_instituciones di 
                    WHERE vdi.codigo_establecimiento = di.codigo_establecimiento
                    AND vdi.periodo = di.periodo)
                 As t)
                As institucion
                FROM v_directorios_instituciones vdi WHERE " + condicion + " ORDER BY vdi.codigo_establecimiento ASC"
        else
          msg='Ha ocurrido un error. Inténtelo más tarde.'
        end
      
      end
      results = ActiveRecord::Base.connection.execute(query)
      render :json => results.to_json

    end

  end

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
  

end
