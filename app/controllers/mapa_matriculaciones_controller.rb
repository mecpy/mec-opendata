class MapaMatriculacionesController < ApplicationController

  def index
    
    respond_to do |format|
      format.html {render :layout => 'application_map'}
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
  

end
