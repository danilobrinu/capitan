# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  survey_id      :integer
#  sprint_id      :integer
#  question_type  :string(255)
#  question_text  :string(255)
#  position       :integer
#  answer_options :text(65535)
#  min_label      :string(255)
#  max_label      :string(255)
#  jedi           :integer
#  question_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Question < ActiveRecord::Base
  belongs_to :survey, :inverse_of => :questions
  belongs_to :sprint
  has_many :answers
  has_one :question, class_name: "Question", foreign_key: 'question_id'

  default_scope { order(:position) }

  validates :survey, :question_text, :presence => true

  def options
    answer_options.split(",").map do |option|
      option.split("|")[0]
    end
  end

  def option_with_labels(aditional=nil)
    spliting_logic = ->(option) {
      o = option.split("|")
      o[0] = o[0] + "-#{aditional}" if aditional != nil
      return o
    }
    answer_options.split(",").map(&spliting_logic)
  end

  def process_data data
    answer
    case question_type
    when "teacher"
      answer = data.map { |k,v| "#{k}|#{v['value']}" }.join(",")
    when "jedi"
      d = data["value"].split("-")
      answer = "#{d[1]}|#{d[0]}"
    when "text"
      answer = data["value"]
    when "lesson"
      answer = data.map { |k,v| "#{k}|#{v['value']}" }.join(",")
    when "checkbox"
      answer = data["value"]
    when "checkbox_horizontal"
      answer = data["value"]
    end
  end

  def teachers
    sprint.sprint_users.where(jedi:0).includes(:user => :profile)
  end

  def jedis
    sprint.sprint_users.where(jedi:1).includes(:user => :profile)
  end

  def lessons
    sprint.lessons
  end

end
