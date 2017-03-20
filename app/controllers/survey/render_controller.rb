class Survey::RenderController < ApplicationController
  before_action do
    check_allowed_roles(current_user, ["student","assistant","teacher","admin"])
  end

  def show
    @survey = Survey.find(params[:id])
    @teachers = ["Lead Teacher","Lead Teacher","Teacher Assistant 1","Teacher Assistant 2", "Teacher Assistant 3"]
    @jedis = ["Ale", "Andrea Lamas","Arabela","Elizabeth","Lalo","Mafe","Malu","Meche","Michelle","Papu"]
    @temas = ['Introducción al desarrollo web', 'HTML/ HTML5 y JavaScript en el navegador','Manejo de comandos básicos de git en la terminal','Pruebas unitarias','Git/ Resolución de conflictos/ Branching model','DOM 101']
  end
end
