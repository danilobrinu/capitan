# == Schema Information
#
# Table name: attempts
#
#  id         :integer          not null, primary key
#  survey_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Attempt < ActiveRecord::Base
  belongs_to :survey
  belongs_to :user
  has_many :answers, inverse_of: :attempt, autosave: true
end
