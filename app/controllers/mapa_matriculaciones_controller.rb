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



class MapaMatriculacionesController < ApplicationController
  before_filter :set_headers

  def index
    
    respond_to do |format|
      format.html {
        if params[:embedded].present? and params[:embedded] == 'true'
          render :layout => 'application_embedded'
        else
          render :layout => 'application_map'
        end
      }
      format.json { self.resumen_json }
    end
  end
  
  def resumen_json

    cond = []
    args = []

    if params[:anho].present?

      cond << "anho = ?"
      args << params[:anho]

    end
    
    if params[:nivel].present?

      cond << "nivel = ?"
      args << params[:nivel]

    end

    if params[:subnivel].present?

      cond << "subnivel = ?"
      args << params[:subnivel]

    end

    if params[:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << params[:nombre_zona]

    end

    if params[:sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion = ?"
      args << params[:sector_o_tipo_gestion]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0


    @matriculaciones = cond.size > 0 ? MapaMatriculacion.where(cond).
                                        group(:nombre_departamento).sum(:cantidad) :
                                       MapaMatriculacion.group(:nombre_departamento).sum(:cantidad)
    
    render :json => @matriculaciones.to_json

  end

   def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
  

end
