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
class Question < ActiveRecord::Base
  belongs_to :survey, :inverse_of => :questions
  has_many :answers

  has_and_belongs_to_many :sprint_users

  default_scope { order(:position) }

  validates :survey, :question_text, :presence => true

end
