module SurveyHelper
  def render_question_helper(question)
    partial = question.type.to_s.split("::").last.downcase
    render partial: "survey/render/questions/#{partial}", locals: { question: question }
  end
end
