# == Schema Information
#
# Table name: surveys
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  introduction :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Survey < ActiveRecord::Base
  has_many :questions
  validates :name, :presence => true
end
