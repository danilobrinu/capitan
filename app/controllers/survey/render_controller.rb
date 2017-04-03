class Survey::RenderController < ApplicationController
  before_action do
    check_allowed_roles(current_user, ["student","assistant","teacher","admin"])
  end

  def show
    @survey = Survey.find(params[:id])
  end

  def saveAnswers
    p params
    form = params[:survey_form]
    survey = Survey.find(form[:survey_id])
    if survey
      prev_attempt = Attempt.find_by_survey_id(survey.id)
      if prev_attempt and survey.single_attempt
        render :show, notice: "Gracias por intentarlo pero sólo se puede
                               enviar el formulario una vez."
      end
      attempt = Attempt.new(survey:survey,user: current_user)
      form[:questions].each do |question_id,data|
        question = Question.find(question_id)
        answer = Answer.new
        answer.question = question
        answer.answer_text = question.process_data(data)
        attempt.answers << answer
      end
      respond_to do |format|
        if attempt.save
          format.html { redirect_to survey_thanks_path }
        else
          format.html { render :show }
        end
      end
    end
  end
end
