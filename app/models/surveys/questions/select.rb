# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  survey_id      :integer
#  question_text  :string(255)
#  position       :integer
#  answer_options :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Questions::Select < Question
  validates :answer_options, :presence => true

  def options
    answer_options.split(",")
  end
end
