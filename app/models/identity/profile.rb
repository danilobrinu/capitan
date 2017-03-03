# == Schema Information
#
# Table name: profiles
#
#  id                            :integer          not null, primary key
#  user_id                       :integer
#  name                          :string(255)
#  biography                     :text(16777215)
#  dni                           :string(255)
#  district_id                   :integer
#  phone1                        :string(255)
#  phone2                        :string(255)
#  facebook_link                 :text(16777215)
#  major                         :string(255)
#  school                        :string(255)
#  reasons_school_not_done       :integer
#  job_status                    :integer
#  work_for                      :integer
#  work_for_details              :string(255)
#  job_title                     :string(255)
#  job_payroll                   :boolean
#  job_type                      :integer
#  job_salary_id                 :integer
#  family_income_id              :integer
#  relatives                     :integer
#  childs                        :boolean
#  tech_savy                     :integer
#  other_tech_related_activities :text(65535)
#  computer_at_home              :boolean
#  internet_access               :boolean
#  smartphone                    :boolean
#  computer_use                  :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  birth_date                    :date
#  education_id                  :integer
#  semesters_left_id             :integer
#  spot_id                       :integer
#  reasons_to_enter              :text(16777215)
#  how_you_find_out              :text(16777215)
#  what_is_laboratoria           :text(16777215)
#  student_lifespan              :text(16777215)
#  github                        :string(255)
#  linkedin                      :string(255)
#  portafolio                    :string(255)
#

class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :district
  belongs_to :job_salary
  belongs_to :family_income
  belongs_to :education
  belongs_to :semesters_left
  belongs_to :spot
  has_and_belongs_to_many :tech_related_activities

  enum reasons_school_not_done: [:studing,:economic_problems,:health_problems,:dont_like_it,:it_wasnt_what_i_expected,:others] unless instance_methods.include? :reasons_school_not_done
  enum job_status: [:working, :work_before_not_working_now,:never_work_before] unless instance_methods.include? :job_status
  enum work_for: [:company,:independent,:other] unless instance_methods.include? :work_for
  enum job_type: [:fulltime,:partime,:intership] unless instance_methods.include? :job_type
  enum computer_use: [:every_day,:few_week,:few_month,:almost_never] unless instance_methods.include? :computer_use

  def self.enum_labels profile_enum, profile_enum_name
    profile_enum.map do |option, _|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{profile_enum_name}.#{option}"), option]
    end
  end
end
