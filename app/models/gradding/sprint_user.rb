# == Schema Information
#
# Table name: sprint_users
#
#  id         :integer          not null, primary key
#  sprint_id  :integer
#  user_id    :integer
#  jedi       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SprintUser < ActiveRecord::Base
  belongs_to :sprint
  belongs_to :user
end
