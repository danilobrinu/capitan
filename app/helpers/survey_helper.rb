module SurveyHelper
  def render_question_helper(form, question)
    render partial: "survey/render/questions/#{question.question_type}", locals: { f: form, question: question }
  end
end
