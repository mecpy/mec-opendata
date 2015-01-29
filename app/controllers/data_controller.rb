# -*- encoding : utf-8 -*-
class DataController < ApplicationController
  
  def datos
    
  end
  
  def index
    
  end

  def about

  end

  def legal

  end

  def contactos

  end

  def contactos_lista

    cond = []
    args = []
    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if params[:form_ordenar_contactos]

      ordenado = "fecha desc, hora desc" if params[:form_ordenar_contactos][:orden] == '1'
      ordenado = "asunto" if params[:form_ordenar_contactos][:orden] == '2'

    else

      ordenado = "fecha desc, hora desc"
    
    end

    @contactos = Contacto.paginate(page: params[:page], per_page: 15).order(ordenado)

    @total_registros = Contacto.count 

     
    respond_to do |f|

      f.js

    end 

  end

  def contactos_guardar

    @contacto = Contacto.new(params[:contacto])
    @valido = true
    @msg = ""

    if params[:contacto] && params[:contacto][:nombre].present?
      @contacto.nombre = params[:contacto][:nombre]
    else
      @valido = false
      @msg += "El campo nombre no puede quedar vacio."
    end

    if params[:contacto] && params[:contacto][:apellido].present?
      @contacto.apellido = params[:contacto][:apellido]
    else
      @valido = false
      @msg += "El campo nombre no puede quedar vacio."
    end

    if params[:contacto] && params[:contacto][:email].present?

      if @contacto.email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

        @contacto.email = params[:contacto][:email]

      else

        @valido = false
        @msg += "Formato de email no valido."

      end
    else
      @valido = false
      @msg += "El campo email no puede quedar vacio."
    end

    if params[:contacto] && params[:contacto][:asunto].present?
      @contacto.asunto = params[:contacto][:asunto]
    else
      @valido = false
      @msg += "El campo asunto no puede quedar vacio."
    end

    if params[:contacto] && params[:contacto][:categoria_contacto_id].present?
      @contacto.categoria_contacto_id = params[:contacto][:categoria_contacto_id]
    else
      @valido = false
      @msg += "Seleccione la categoria."
    end

    if params[:contacto] && params[:contacto][:mensaje].present?
      @contacto.mensaje = params[:contacto][:mensaje]
    else
      @valido = false
      @msg += "El campo mensaje no puede quedar vacio."
    end

    #unless verify_recaptcha
    #  @valido = false
    #  @msg += "Código de verificación no valido.".html_safe   
    #end

    if @valido

      @contacto.fecha = Time.now.strftime("%Y-%m-%d")
      @contacto.hora = Time.now.strftime("%H:%M:%S")
      
      if @contacto.save
        
        @enviado = true 

      else
        
        @enviado = false
      
      end

    end

    respond_to do |f|
      f.js
    end

  end

  def ejemplo_anio_cod_geo

  end

end
