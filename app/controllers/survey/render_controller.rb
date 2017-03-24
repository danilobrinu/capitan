class Survey::RenderController < ApplicationController
  before_action do
    check_allowed_roles(current_user, ["student","assistant","teacher","admin"])
  end

  def show
    @survey = Survey.find(params[:id])
  end

  def saveAnswers
    survey = Survey.find(params[:survey_id])
    if survey
      prev_attempt = Attempt.find_by_survey_id(survey.id)
      render :show, notice: "Gracias por intentarlo pero sólo se puede enviar el formulario una vez."
      questions = params[:survey_form]
      questions.each do |question_id,value|
        question = Question.find(question_id)

      end
    end
  end
end
