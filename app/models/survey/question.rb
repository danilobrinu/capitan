# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  survey_id     :integer
#  question_text :string(255)
#  position      :integer
#  min_value     :integer
#  max_value     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Question < ActiveRecord::Base
  belongs_to :survey, :inverse_of => :questions
  has_many :answers

  default_scope { order(:position) }

  validates :survey, :question_text, :presence => true

  def self.inherited(child)
    child.instance_eval do
      def model_name
        Question.model_name
      end
    end
    super
  end

end
