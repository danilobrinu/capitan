class Teacher::DashboardController < ApplicationController

  before_action do
    check_allowed_roles(current_user, ["assistant","teacher","admin"])
  end

  layout "teacher"

  def class_stats
  end

  def students
  end

  def teacher_stats
  end

  def grades_filters
      @branches = Branch.all
      @soft_skills = SoftSkill.stypes
      render 'grades_filter'
  end

  def grades_input
    if request.post?
      params[:input][:grades].each { |user_id,grades|
      grades.each { |page_id,grade|
          if grade.first != nil
            submission = Submission.find_or_initialize_by(user_id: user_id,page_id:page_id)
            submission.points = grade.first
            submission.save
          end
        }
      }

      params[:page_id] = params[:input][:page_id]
      params[:sprint_id] = params[:input][:sprint_id]
      params[:lesson_id] = params[:input][:lesson_id]
      params[:group_id] = params[:input][:group_id]

      flash[:success] = "Notas grabadas exitosamente"
    end

    @sprint = Sprint.find(params[:sprint_id])
    @group  = Group.find(params[:group_id])
    @lesson = SprintPage.
               joins(:page => :lesson).
               where("sprint_id = ? and coalesce(sprint_pages.points,pages.points) > 0 and lessons.id = ?",params[:sprint_id],params[:lesson_id]).
               pluck("pages.id","coalesce(sprint_pages.points,pages.points) as points","pages.title","lessons.title","pages.page_type").
               group_by { |e| e[3] }.first

    @users  = User.includes(:profile).where(group_id: params[:group_id], role: 1, disable:false)
    @submissions = Submission.where(user_id: @users.map { |u| u.id }).map { |s| [s.page_id,s.user_id,s.points]}
  end

  def grades_softskill
    if request.post?
      for i in 0..params[:input][:users].size
        if params[:input][:grades] != nil
          params[:input][:grades].each { |k,v|
            if v[i] != nil
              submission = SoftSkillSubmission.find_or_initialize_by(user_id: params[:input][:users][i],soft_skill_id:k)
              submission.sprint_id = params[:input][:sprint_id]
              submission.points = v[i]
              submission.save
            end
          }
        end
      end
      params[:sprint_id] = params[:input][:sprint_id]
      params[:group_id] = params[:input][:group_id]
      params[:stype] = params[:input][:stype]
      flash[:success] = "Soft Skills grabados exitosamente"
    end

    @sprint = Sprint.find(params[:sprint_id])
    @group  = Group.find(params[:group_id])
    @softskill = SoftSkill.stypes.keys[0].capitalize
    @soft_skills = SprintSoftSkill.where(sprint_id:params[:sprint_id]).joins(:soft_skill).
                   where("soft_skills.stype":params[:stype]).
                   pluck_to_hash("soft_skills.id as id","soft_skills.name as name","coalesce(sprint_soft_skills.points,soft_skills.max_points) as points")
    @users  = User.includes(:profile).where(group_id: params[:group_id], role: 1, disable:false)
    @submissions = SoftSkillSubmission.where(sprint_id:params[:sprint_id],user_id: @users.map { |u| u.id }).map { |s| [s.user_id,s.soft_skill_id,s.points]}

  end

  def grades_filter
    status, message = "ok", "success"
    begin
      case params[:filter]
      when "group"
        result = Group.where(branch_id: params[:options][:branch_id]).pluck(:id, :name)
      when "sprint"
        result = Sprint.where(group_id: params[:options][:group_id]).pluck(:id,:name)
      when "lesson"
        lesson_points = SprintPage.joins(:page => :lesson).
                                   joins(:sprint).
                                   where("sprints.id = ?",params[:options][:sprint_id]).
                                   group("lessons.id, lessons.title").
                                   pluck("lessons.id","lessons.title","coalesce(sum(coalesce(sprint_pages.points,pages.points)),0)")

        result = lesson_points.select { |l| l[2] > 0 }
      end
    rescue => error
      p error
      status = "fail"
      message = "No pudimos obtener el filtro solicitado"
    end
    render :json => { status: status, message: message, data: result }
  end

  def assistance
  end

  def sprints
  end

  def recomendations
  end
end
