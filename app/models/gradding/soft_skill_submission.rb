# == Schema Information
#
# Table name: soft_skill_submissions
#
#  id            :integer          not null, primary key
#  soft_skill_id :integer
#  user_id       :integer
#  sprint_id     :integer
#  points        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class SoftSkillSubmission < ActiveRecord::Base
  belongs_to :soft_skill
  belongs_to :user
  belongs_to :sprint

  scope :for_user, -> (user) {
  		where(user_id: user.id).
  		joins(:soft_skill).
  		group(:stype).
  		pluck_to_hash(:stype,'sum(points) as points')
  }

  scope :avg_classroom_points, -> (user) {
      joins(:soft_skill,:user).
      where("users.group_id = ?",user.group_id).
      group(:user_id,:stype).
      pluck(:user_id,:stype,'sum(points)').
      group_by { |e| e[1] }.
      map { |k,v| [k,v.length,v.map{|f| f[2]}.reduce(&:+)]}.
      map { |e| [e[0],(e[2]*1.0/e[1]).round(2)]}
  }

  scope :students_technical_points, -> (group_id) {
    joins(:user => :profile).
    where("users.group_id = ? and users.role = 1 and users.disable = 0",group_id).
    group("users.id","users.code","profiles.name").
    order("points desc").
    pluck("users.id","users.code","profiles.name","CAST(sum(points) as UNSIGNED)")
  }
end
