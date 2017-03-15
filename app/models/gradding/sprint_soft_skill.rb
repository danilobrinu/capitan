# == Schema Information
#
# Table name: sprint_soft_skills
#
#  id            :integer          not null, primary key
#  sprint_id     :integer
#  soft_skill_id :integer
#  points        :decimal(11, 2)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class SprintSoftSkill < ActiveRecord::Base
  belongs_to :sprint
  belongs_to :soft_skill

  scope :with_points, -> { where("sprint_soft_skills.points > 0 or soft_skills.max_points > 0") }

  def self.total_points group_id, sprint_id
    if sprint_id != nil
      with_points.
      joins({:sprint => :group}, :soft_skill).
      where("groups.id = ? and sprint_id = ?",group_id,sprint_id).
      group(:stype).
      pluck(:stype, 'round(sum(coalesce(sprint_soft_skills.points,soft_skills.max_points)))')
    else
      with_points.
      joins({:sprint => :group}, :soft_skill).
      where("groups.id = ? ",group_id).
      group(:stype).
      pluck(:stype, 'round(sum(coalesce(sprint_soft_skills.points,soft_skills.max_points)))')
    end
  end

  def self.student_points user
    with_points.
    joins({sprint: :group}, :soft_skill).
    joins("join soft_skill_submissions on soft_skill_submissions.soft_skill_id = soft_skills.id and sprints.id = soft_skill_submissions.sprint_id").
    where('soft_skill_submissions.user_id = ? and groups.id = ?', user.id, user.group_id).
    references(:soft_skills_submissions).group(:stype).
    pluck(:stype, 'round(coalesce(sum(soft_skill_submissions.points),0))')
  end

end
