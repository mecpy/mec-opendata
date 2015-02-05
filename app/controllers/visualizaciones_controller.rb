# -*- encoding : utf-8 -*-
class VisualizacionesController < ApplicationController
  
  before_filter :redireccionar_uri

  def index
    
  end

  def academia_funcionarios_docentes

  end

  def academia_funcionarios_administrativos

  end

  def academia_inventario_bienes_rodados

  end

  def academia_inventario_bienes_inmuebles

  end

  def academia_inventario_bienes_muebles

    respond_to do |f|

      f.html {render :layout => 'application'}

    end

  end

end
