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

        results = File.read("#{Rails.root}/app/assets/javascripts/geometrias/instituciones_2014.json")

      elsif params[:tipo_consulta]=='13'

        codigo_establecimiento = params[:establecimiento]
        
        instituciones = VDirectorioInstitucion.
          select("periodo, codigo_institucion, nombre_institucion").
          where(codigo_establecimiento: codigo_establecimiento).
          order("codigo_institucion desc, periodo asc")

        ci = ''
        results = Array.new()
        institucion = Object.new()
        contador = 0

        instituciones.each do |i|

          cantidad_matriculados = cantidad_total_matriculados_por_anio(codigo_establecimiento, i.codigo_institucion, i.periodo)
          if cantidad_matriculados == 0
            cantidad_matriculados = "--"
          end

          periodo_matriculacion = { "#{i.periodo}" => cantidad_matriculados.to_s }

          if ci == i.codigo_institucion
            institucion['cantidad_matriculados'] << periodo_matriculacion
          else
            if ci != ''
              contador = contador + 1
            end
            ci = i.codigo_institucion
            institucion = Object.new()
            institucion = { "codigo_institucion" => i.codigo_institucion, "nombre_institucion" => i.nombre_institucion, "cantidad_matriculados" => [] }
            institucion['cantidad_matriculados'] << periodo_matriculacion
            results[contador] = institucion
          end

        end

        #results = Array.new
        #for i in instituciones
        #  results << {i.periodo, i.codigo_institucion, i.nombre_institucion}
        #end
        #query = ""
        #results = ActiveRecord::Base.connection.execute(query)
      
      end

      #beginning_time = Time.now
      #end_time = Time.now
      #puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"
      
      render :json => results
      end_time = Time.now
      puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"

    end

  end

  def cantidad_total_matriculados_por_anio(codigo_establecimiento, codigo_institucion, anio)

    total_eeb = MatriculacionEducacionEscolarBasica.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("total_matriculados")
    total_ei = MatriculacionEducacionInclusiva.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_inicial_especial+matricula_primer_y_segundo_ciclo_especial+matricula_tercer_ciclo_especial+matricula_programas_especiales")
    total_ep = MatriculacionEducacionPermanente.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_ebbja+matricula_fpi+matricula_emapja+matricula_emdja+matricula_fp")
    total_es = MatriculacionEducacionSuperior.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_ets+matricula_fed+matricula_fdes+matricula_pd")
    total_i = MatriculacionInicial.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("total_matriculados")
    total_em = MatriculacionEducacionMedia.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_cientifico+matricula_tecnico+matricula_media_abierta+matricula_formacion_profesional_media")

    (total_eeb.to_i + total_ei.to_i + total_ep.to_i + total_es.to_i + total_i.to_i + total_em.to_i)

  end

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
  
end