# == Schema Information
#
# Table name: soft_skills
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  max_points  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text(65535)
#  stype       :integer
#

class SoftSkill < ActiveRecord::Base

	has_many :sprint_soft_skills, dependent: :destroy
	has_many :sprints, through: :sprint_soft_skills
	has_many :soft_skill_submissions, :dependent => :destroy
	enum stype: [:excellence,:communication,:teamwork,:adaptability,:attendance] unless instance_methods.include? :stype

	validates :name, presence: true

end
