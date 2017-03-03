# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text(65535)
#  color       :string(255)
#  code        :string(255)
#  points      :integer
#  track_id    :integer
#  course_plan :string(255)
#  level       :integer
#  audience    :integer
#

class Course < ActiveRecord::Base

    validates :name, presence: true

    enum audience: [:beginner, :intermediate, :advance] unless instance_methods.include? :audience

    belongs_to :track
    has_many :units, :dependent => :destroy

    def get_course_sum_points
      points = 0
      Page.get_editor_pages_for_course(self.id).each do |page|
          points += page.points if page.points != nil
      end
      Page.get_question_pages_for_course(self.id).each do |page|
           points += page.question_points * page.question_groups.count if page.question_points != nil
      end
      points
    end

    def has_pages(branch_id)
      query = "select count(p.id)
               from pages p
               inner join lessons l on p.lesson_id = l.id
               inner join units u on l.unit_id = u.id
               inner join courses c on c.id = u.course_id
               inner join page_visibilities pv on p.id = pv.page_id
               where c.id = #{self.id} and branch_id = #{branch_id} and pv.status = 1"
      ActiveRecord::Base.connection.execute(query).first[0] > 0
    end

    def total_points
      self.units.sum(:points)
    end

    def duration
      units.sum(:duration)
    end

end
