require 'roo'
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string(255)
#  uid                    :string(255)
#  code                   :string(255)
#  disable                :boolean          default(FALSE)
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  role                   :integer          default(0)
#  group_id               :integer
#  recomended_as          :integer          default(0)
#  hire                   :boolean          default(FALSE)
#

class User < ActiveRecord::Base

  after_initialize :build_default_profile
  before_validation :generate_code
  before_validation :generate_password

  enum role: [:applicant, :student, :assistant, :teacher, :admin, :employer]  unless instance_methods.include? :role
  enum recomended_as: [:frontend, :prototype] unless instance_methods.include? :recomended_as

  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy
  belongs_to :group
  has_many :answers , :dependent => :destroy
  has_many :pages, through: :answers
  has_many :enrollments, :dependent => :destroy
  has_many :courses, through: :enrollments
  has_many :submissions, :dependent => :destroy
  has_many :soft_skill_submissions, :dependent => :destroy
  has_many :pages, through: :submissions
  has_many :primary_reviews, :class_name => "Review", :foreign_key => "user_id"
  has_many :secondary_reviews, :class_name => "Review", :foreign_key => "reviewer_id"
  has_and_belongs_to_many :sprint_badges, :dependent => :destroy
  has_one :profile, :dependent => :destroy

  accepts_nested_attributes_for :profile

  devise :database_authenticatable,:registerable,:recoverable,:rememberable,
         :trackable,:omniauthable,:omniauth_providers => [:github]

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create
  validates :group_id, presence: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email,:with => Devise::email_regexp

  has_attached_file :avatar,
                    :styles => { :large => "200x200", :profile => "128x128", :menu => "80x80", :student_dashboard => "94x94", :navbar => "35x35" },
                    :url => "/system/:class/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/:class/:id/:style/:basename.:extension",
                    :default_url => (self.student ? "/alumna.png" : "profesor.png")

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # TODO: PODER VINCULAR MI CUENTA CON GITHUB, ESTO QUEDO A MEDIAS
  def self.create_from_omniauth(params)
    attributes = {
      name: params['info']['name'],
      email: params['info']['email'],
      password: Devise.friendly_token
    }

    create(attributes)
  end

  def full_name
    profile.nil? or profile.name.blank? ? self.email : profile.name.strip
  end

  #Devise custom methods
  def email_required?
    false
  end

  def branch
    self.group.branch if group != nil
  end

  def signup_branch
    self.group.branch_id if group != nil
  end

  def signup_branch=(branch_id)
    self.group = Group.where(branch_id: branch_id,accepting_latest_users: true).order("name desc").first
  end

  def sprints
    self.group.sprints if group != nil
  end

  def skill_points page_type
    self.pages.where(page_type: page_type).pluck('submissions.points').map(&:to_i).sum
  end

  def badge_points sprint
    self.sprint_badges.where(sprint_id: sprint.id).joins(:badge).pluck('sum(badges.points)').first
  end

  private

  def build_default_profile
      self.profile ||= Profile.new if self.new_record?
  end

  def generate_code
    if self.code.nil?
      self.code = next_code
    end
  end

  def generate_password
    if self.password.nil?
      code = next_code
      self.password = code.gsub(/\D/,'') if !next_code.nil?
    end
  end

  def next_code
    if !self.group.nil?
      last_code = User.where(role: [0,1],group_id: self.group.id).
                      where("code like 'LIM%' or code like 'SCL%' or code like 'MEX%' or code like 'AQP%'").
                      order("cast(substring(code,4,length(code)) as unsigned) desc").pluck("code").first

      if last_code != nil
        last_code[0..7] + (last_code[8..-1].to_i + 1).to_s.rjust(3,"0")
      else
        last_code = "#{self.group.name}001"
      end
    end
  end

end
