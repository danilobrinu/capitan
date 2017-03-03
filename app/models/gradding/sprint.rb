# == Schema Information
#
# Table name: sprints
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  group_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sequence    :integer
#

class Sprint < ActiveRecord::Base
  has_many :badges, through: :sprint_badges
  has_many :sprint_badges, dependent: :destroy
  belongs_to :group
  has_many :submissions, through: :pages
  has_many :soft_skill_submissions, dependent: :destroy
  has_many :sprint_pages, dependent: :destroy
  has_many :sprint_soft_skills, dependent: :destroy
  has_many :sprint_users, dependent: :destroy

  has_many :pages, through: :sprint_pages
  has_many :lessons, -> { distinct }, through: :pages
  has_many :soft_skills, through: :sprint_soft_skills
  has_many :users, through: :sprint_users


  accepts_nested_attributes_for :sprint_pages
  accepts_nested_attributes_for :soft_skills
  accepts_nested_attributes_for :sprint_users

  validates :group_id, presence: true

  def total_points
    sprint_pages.with_points.
    joins(:page).
    group("pages.page_type").
    pluck("pages.page_type","round(sum(coalesce(sprint_pages.points,pages.points)))")
  end

  def student_points user
    sprint_pages.with_points.
    includes({page: :submissions}).
    where('submissions.user_id = ?', user.id).
    references(:submissions).group(:page_type).
    pluck(:page_type, 'round(sum(submissions.points))')
  end

  def avg_classroom_points
      sprint_pages.with_points.
      includes({page: :submissions}).
      group(:user_id).
      pluck('round(sum(submissions.points))').
      reduce [ 0.0, 0 ] do |(s, c), e| [ s + e, c + 1 ] end.reduce :/
  end
end
