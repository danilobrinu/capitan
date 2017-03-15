class ProfileController < ApplicationController

  before_action only: [:myprofile, :codereview] do
    check_allowed_roles(current_user, ["student","assistant","teacher","admin"])
  end

  before_action only: [:selection, :selection_success] do
    check_allowed_roles(current_user, ["applicant"])
  end

  def myprofile
    @max_total_points, @max_student_points = 0, 0
    @data = []
    @sprint_index = 0

    @user = current_user

    @sprints = @user.group.sprints.joins(:pages).where("pages.points > 0 or sprint_pages.points > 0").order(:sequence).distinct
    @sprint_badges = @user.sprint_badges.group_by(&:badge).map { |key,value| {key => value.size} }

    if @sprints.length > 0
      if params[:sprint_id].present?
        @sprint = Sprint.find(params[:sprint_id])
        @selected_sprint_name = @sprint.name
        @maximum_points = capitalize_page_type(@sprint.total_points) # can be an empty array
        @student_points = @sprint.student_points(@user)
        @soft_skills_points = @sprint.soft_skill_submissions.for_user(@user)
        @soft_skills_max_points = SprintSoftSkill.total_points(@user.group_id,@sprint.id)
        @avg_students_points = Submission.avg_classroom_points(current_user.group_id,@sprint.id)
        @badge_points = @user.badge_points(@sprint)
      else
        @selected_sprint_name = "Total"
        @maximum_points = capitalize_page_type(SprintPage.total_points(@user.group_id))
        @student_points = SprintPage.student_points(@user)
        @soft_skills_points = SoftSkillSubmission.for_user(@user)
        @soft_skills_max_points = SprintSoftSkill.total_points(@user.group_id,nil)
        @avg_students_points = Submission.avg_all_classroom_points(current_user.group_id)
        @badge_points = @user.sprint_badges.joins(:badge).pluck('badges.points').reduce(&:+)
      end

      #Badge points should not add to the maximum points available
      #A student can get 2500 / 2000 if she gets all points and all badges
      @maximum_points << ["badges", @badge_points != nil ? @badge_points : 0]
      @student_points << ["badges", @badge_points != nil ? @badge_points : 0]
      @student_points = capitalize_page_type(@student_points) # can be an empty array
      @max_total_points = @maximum_points.map {|e| e[0] != "badges" ? e[1] : 0}.sum

      if !@maximum_points.empty? and @maximum_points.length == @student_points.length
        @data = @maximum_points.zip(@student_points).map { |arr|
          { name: arr.first.first,
            y: arr.first.last,
            student_marks: arr.last.last
          }
        }
        @data = @data.select{ |x| x[:y] > 0 }

        @max_total_points = sum_points(@data, :y) - (@badge_points != nil ? @badge_points : 0)
        @max_student_points = sum_points(@data, :student_marks)

        @soft_skills_points.each do |ssp|
          ssp["max_points"] = @soft_skills_max_points.select { |x| x[0] == ssp["stype"]}[0][1]
        end

      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def codereview
    @reviews = Review.where(user_id: current_user.id)
    @pages = Page.where(page_type: "codereview").order(:lesson_id)
  end

  def admission
    render :layout => "devise"
  end

  def admission_success
    render :layout => "devise"
  end

  def selection
    render :layout => "devise"
  end

  def selection_success
    render :layout => "devise"
  end

  private

  def capitalize_page_type points
    points.map {|element| [element[0].capitalize, element[1] ] }
  end

  def sum_points data_arr, page_type
    data_arr.map {|e| e[page_type]}.reduce(&:+)
  end
end
