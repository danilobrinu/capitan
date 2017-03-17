# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  attempt_id  :integer
#  question_id :integer
#  answer_text :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :attempt, inverse_of: :answers

  validates :question, :attempt, presence: true


end
