class Admin::SprintsController < ApplicationController
  before_action :set_sprint, only: [:show, :edit, :update, :destroy]
  before_action do
    check_allowed_roles(current_user, ["assistant","teacher","admin"])
  end

  layout 'admin'

  def index
    @branches = Branch.all

    # Admin has to belong to a group;
    # otherwise the following statement won't works
    @group_id = current_user.group_id
    @sprints = Group.find(@group_id).sprints
  end

  def show
    @lessons = @sprint.lessons
    @soft_skills = @sprint.soft_skills.all.group_by(&:stype)
    @teachers = @sprint.users.where("sprint_users.jedi = ? ", false)
    @jedis = @sprint.users.where("sprint_users.jedi = ? ", true)
  end

  def group_sprints
    @group = Group.find(params[:group_id])
    @sprints = @group.sprints
    respond_to :js
  end

  def new
    @sprint = Sprint.new
    load_new_edit_info
  end

  def edit
    @sprint_pages_ids = @sprint.sprint_pages.pluck(:page_id,:points)
    load_new_edit_info
  end

  def load_new_edit_info
    @tracks = Track.all.includes(:courses => {:units => {:lessons => :pages}})
    @soft_skills = SoftSkill.all.group_by(&:stype)
    @users_by_branch = User.all.
                       includes(:profile,{:group => :branch}).
                       where(role: [User.roles[:assistant],
                                   User.roles[:teacher],
                                   User.roles[:admin]]).
                       group_by(&:branch)
  end

  def create
    # An extra empty string is always passed as a part of
    # sprint_params[lesson_ids] because of the hidden checkbox field whose
    # value is "". For more, see  #http://apidock.com/rails/ActionView/Helpers/FormHelper/check_box#1001-Sending-array-parameters
    # However without the following line of code, it works.
    # sprint_params['lesson_ids'].delete('')

    @sprint = Sprint.new(sprint_params)

    respond_to do |format|
      update_sprint_pages
      update_sprint_soft_skills
      update_sprint_teachers
      update_sprint_jedis
      if @sprint.save
        format.html { redirect_to [:admin,@sprint], notice: 'Sprint was successfully created.' }
        format.json { render :show, status: :created, location: @sprint }
      else
        load_new_edit_info
        format.html { render :new }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      update_sprint_pages
      update_sprint_soft_skills
      update_sprint_teachers
      update_sprint_jedis
      if @sprint.update(sprint_params)
        format.html { redirect_to [:admin,@sprint], notice: 'Sprint was successfully updated.' }
        format.json { render :show, status: :ok, location: @sprint }
      else
        load_new_edit_info
        format.html { render :edit }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_sprint_pages
    @sprint.sprint_pages.destroy_all
    @sprint.save
    params[:sprint_pages].map do |k,sp|
      if sp[:page_id] != nil
        SprintPage.create(sprint:@sprint,page_id: sp[:page_id],points: sp[:points])
      end
    end
    params[:sprint].delete(:sprint_pages)
  end

  def update_sprint_soft_skills
    @sprint.sprint_soft_skills.destroy_all
    @sprint.save
    params[:sprint_soft_skills].map do |k,sp|
      if sp[:soft_skill_id] != nil
        SprintSoftSkill.create(sprint:@sprint,soft_skill_id: sp[:soft_skill_id],points: sp[:points])
      end
    end
    params[:sprint].delete(:sprint_soft_skills)
  end

  def update_sprint_teachers
    if params[:sprint_teachers] != nil
      @sprint.sprint_users.where(jedi:false).destroy_all
      @sprint.save
      params[:sprint_teachers].map do |k,t|
        if t[:user_id] != nil
          SprintUser.create(sprint:@sprint,user_id: t[:user_id],jedi:false)
        end
      end
      params[:sprint].delete(:sprint_teachers)
    end
  end

  def update_sprint_jedis
    if params[:sprint_jedis] != nil
      @sprint.sprint_users.where(jedi:true).destroy_all
      @sprint.save
      params[:sprint_jedis].map do |k,t|
        if t[:user_id] != nil
          SprintUser.create(sprint:@sprint,user_id: t[:user_id],jedi:true)
        end
      end
      params[:sprint].delete(:sprint_jedis)
    end
  end

  def destroy
    @sprint.destroy
    respond_to do |format|
      format.html { redirect_to admin_sprints_url, notice: 'Sprint was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sprint
      @sprint = Sprint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sprint_params
      params.require(:sprint).permit(:name, :description, :sequence, :group_id, page_ids: [], badge_ids: [], soft_skill_ids: [])
    end
end
