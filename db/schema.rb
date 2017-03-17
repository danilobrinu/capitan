# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170316223237) do

  create_table "Questions_SprintUsers", id: false, force: :cascade do |t|
    t.integer "question_id",    limit: 4, null: false
    t.integer "sprint_user_id", limit: 4, null: false
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "attempt_id",  limit: 4
    t.integer  "question_id", limit: 4
    t.text     "answer_text", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "answers", ["attempt_id"], name: "index_answers_on_attempt_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "attempts", force: :cascade do |t|
    t.integer  "survey_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "attempts", ["survey_id"], name: "index_attempts_on_survey_id", using: :btree
  add_index "attempts", ["user_id"], name: "index_attempts_on_user_id", using: :btree

  create_table "authentication_providers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "authentication_providers", ["name"], name: "index_name_on_authentication_providers", using: :btree

  create_table "badges", force: :cascade do |t|
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.string   "name",               limit: 255
    t.integer  "points",             limit: 4,   default: 0
  end

  create_table "branches", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "code",       limit: 255
    t.string   "address",    limit: 255
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.integer  "holder_id",         limit: 4
    t.integer  "commentable_id",    limit: 4
    t.string   "commentable_type",  limit: 255
    t.string   "commentable_url",   limit: 255
    t.string   "commentable_title", limit: 255
    t.string   "commentable_state", limit: 255
    t.string   "anchor",            limit: 255
    t.string   "title",             limit: 255
    t.string   "contacts",          limit: 255
    t.text     "raw_content",       limit: 65535
    t.text     "content",           limit: 65535
    t.string   "view_token",        limit: 255
    t.string   "state",             limit: 255,   default: "draft"
    t.string   "ip",                limit: 255,   default: "undefined"
    t.string   "referer",           limit: 255,   default: "undefined"
    t.string   "user_agent",        limit: 255,   default: "undefined"
    t.integer  "tolerance_time",    limit: 4
    t.boolean  "spam",              limit: 1,     default: false
    t.integer  "parent_id",         limit: 4
    t.integer  "lft",               limit: 4
    t.integer  "rgt",               limit: 4
    t.integer  "depth",             limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "description", limit: 65535
    t.string   "color",       limit: 255
    t.string   "code",        limit: 255
    t.integer  "points",      limit: 4
    t.integer  "track_id",    limit: 4
    t.string   "course_plan", limit: 255
    t.integer  "level",       limit: 4
    t.integer  "audience",    limit: 4
  end

  add_index "courses", ["track_id"], name: "index_courses_on_track_id", using: :btree

  create_table "districts", force: :cascade do |t|
    t.integer  "branch_id",  limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "districts", ["branch_id"], name: "index_districts_on_branch_id", using: :btree

  create_table "educations", force: :cascade do |t|
    t.integer  "branch_id",  limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "educations", ["branch_id"], name: "index_educations_on_branch_id", using: :btree

  create_table "enrollments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.boolean  "status",     limit: 1
    t.integer  "track_id",   limit: 4
  end

  add_index "enrollments", ["track_id"], name: "index_enrollments_on_track_id", using: :btree
  add_index "enrollments", ["user_id"], name: "index_enrollments_on_user_id", using: :btree

  create_table "family_incomes", force: :cascade do |t|
    t.integer  "branch_id",  limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "family_incomes", ["branch_id"], name: "index_family_incomes_on_branch_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "description",            limit: 255
    t.integer  "branch_id",              limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "sequence",               limit: 4,   default: 0
    t.boolean  "accepting_latest_users", limit: 1,   default: false
  end

  add_index "groups", ["branch_id"], name: "index_groups_on_branch_id", using: :btree

  create_table "job_salaries", force: :cascade do |t|
    t.integer  "branch_id",  limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "job_salaries", ["branch_id"], name: "index_job_salaries_on_branch_id", using: :btree

  create_table "lessons", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.integer  "unit_id",     limit: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "sequence",    limit: 4,   default: 0
    t.integer  "points",      limit: 4
    t.string   "lesson_plan", limit: 255
  end

  add_index "lessons", ["unit_id"], name: "index_lessons_on_unit_id", using: :btree

  create_table "page_visibilities", force: :cascade do |t|
    t.integer  "page_id",    limit: 4
    t.integer  "branch_id",  limit: 4
    t.boolean  "status",     limit: 1
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "page_visibilities", ["branch_id"], name: "index_page_visibilities_on_branch_id", using: :btree
  add_index "page_visibilities", ["page_id"], name: "index_page_visibilities_on_page_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title",                      limit: 255
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "page_type",                  limit: 255
    t.integer  "sequence",                   limit: 4
    t.text     "instructions",               limit: 65535
    t.text     "html",                       limit: 65535
    t.text     "initial_state",              limit: 65535
    t.text     "solution",                   limit: 65535
    t.string   "success_message",            limit: 255
    t.string   "videotip",                   limit: 255
    t.integer  "points",                     limit: 4
    t.integer  "question_points",            limit: 4
    t.boolean  "selfLearning",               limit: 1,     default: false
    t.boolean  "load_from_previous",         limit: 1
    t.boolean  "auto_corrector",             limit: 1,     default: false
    t.integer  "grade",                      limit: 4,     default: 0
    t.string   "slide_url",                  limit: 255
    t.string   "document_file_name",         limit: 255
    t.string   "document_content_type",      limit: 255
    t.integer  "document_file_size",         limit: 4
    t.datetime "document_updated_at"
    t.text     "excercise_instructions",     limit: 65535
    t.string   "video_solution",             limit: 255
    t.string   "solution_file_file_name",    limit: 255
    t.string   "solution_file_content_type", limit: 255
    t.integer  "solution_file_file_size",    limit: 4
    t.datetime "solution_file_updated_at"
    t.string   "solution_visibility",        limit: 255
    t.integer  "lesson_id",                  limit: 4
    t.string   "material_type",              limit: 255
    t.string   "quiz_url",                   limit: 255
    t.boolean  "show_title",                 limit: 1,     default: true
    t.string   "video_url",                  limit: 255
    t.boolean  "optional",                   limit: 1
    t.string   "code",                       limit: 255
  end

  add_index "pages", ["lesson_id"], name: "index_pages_on_lesson_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",                       limit: 4
    t.string   "name",                          limit: 255
    t.text     "biography",                     limit: 16777215
    t.string   "dni",                           limit: 255
    t.integer  "district_id",                   limit: 4
    t.string   "phone1",                        limit: 255
    t.string   "phone2",                        limit: 255
    t.text     "facebook_link",                 limit: 16777215
    t.string   "major",                         limit: 255
    t.string   "school",                        limit: 255
    t.integer  "reasons_school_not_done",       limit: 4
    t.integer  "job_status",                    limit: 4
    t.integer  "work_for",                      limit: 4
    t.string   "work_for_details",              limit: 255
    t.string   "job_title",                     limit: 255
    t.boolean  "job_payroll",                   limit: 1
    t.integer  "job_type",                      limit: 4
    t.integer  "job_salary_id",                 limit: 4
    t.integer  "family_income_id",              limit: 4
    t.integer  "relatives",                     limit: 4
    t.boolean  "childs",                        limit: 1
    t.integer  "tech_savy",                     limit: 4
    t.text     "other_tech_related_activities", limit: 65535
    t.boolean  "computer_at_home",              limit: 1
    t.boolean  "internet_access",               limit: 1
    t.boolean  "smartphone",                    limit: 1
    t.integer  "computer_use",                  limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.date     "birth_date"
    t.integer  "education_id",                  limit: 4
    t.integer  "semesters_left_id",             limit: 4
    t.integer  "spot_id",                       limit: 4
    t.text     "reasons_to_enter",              limit: 16777215
    t.text     "how_you_find_out",              limit: 16777215
    t.text     "what_is_laboratoria",           limit: 16777215
    t.text     "student_lifespan",              limit: 16777215
    t.string   "github",                        limit: 255
    t.string   "linkedin",                      limit: 255
    t.string   "portafolio",                    limit: 255
  end

  add_index "profiles", ["district_id"], name: "index_profiles_on_district_id", using: :btree
  add_index "profiles", ["education_id"], name: "index_profiles_on_education_id", using: :btree
  add_index "profiles", ["family_income_id"], name: "index_profiles_on_family_income_id", using: :btree
  add_index "profiles", ["job_salary_id"], name: "index_profiles_on_job_salary_id", using: :btree
  add_index "profiles", ["semesters_left_id"], name: "index_profiles_on_semesters_left_id", using: :btree
  add_index "profiles", ["spot_id"], name: "index_profiles_on_spot_id", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "profiles_tech_related_activities", id: false, force: :cascade do |t|
    t.integer "profile_id",               limit: 4, null: false
    t.integer "tech_related_activity_id", limit: 4, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "survey_id",     limit: 4
    t.string   "question_text", limit: 255
    t.integer  "position",      limit: 4
    t.integer  "min_value",     limit: 4
    t.integer  "max_value",     limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "questions", ["survey_id"], name: "index_questions_on_survey_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "page_id",     limit: 4
    t.integer  "question_id", limit: 4
    t.text     "answer",      limit: 65535
    t.integer  "user_id",     limit: 4
    t.integer  "reviewer_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "reviews", ["page_id"], name: "index_reviews_on_page_id", using: :btree
  add_index "reviews", ["question_id"], name: "index_reviews_on_question_id", using: :btree

  create_table "semesters_lefts", force: :cascade do |t|
    t.integer  "branch_id",  limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "semesters_lefts", ["branch_id"], name: "index_semesters_lefts_on_branch_id", using: :btree

  create_table "soft_skill_submissions", force: :cascade do |t|
    t.integer  "soft_skill_id", limit: 4
    t.integer  "user_id",       limit: 4
    t.integer  "sprint_id",     limit: 4
    t.integer  "points",        limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "soft_skill_submissions", ["soft_skill_id"], name: "index_soft_skill_submissions_on_soft_skill_id", using: :btree
  add_index "soft_skill_submissions", ["sprint_id"], name: "index_soft_skill_submissions_on_sprint_id", using: :btree
  add_index "soft_skill_submissions", ["user_id"], name: "index_soft_skill_submissions_on_user_id", using: :btree

  create_table "soft_skills", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "max_points",  limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "description", limit: 65535
    t.integer  "stype",       limit: 4
  end

  create_table "spots", force: :cascade do |t|
    t.integer  "branch_id",  limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "status",     limit: 1
  end

  add_index "spots", ["branch_id"], name: "index_spots_on_branch_id", using: :btree

  create_table "sprint_badges", force: :cascade do |t|
    t.integer  "sprint_id",  limit: 4
    t.integer  "badge_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "sprint_badges", ["badge_id"], name: "index_sprint_badges_on_badge_id", using: :btree
  add_index "sprint_badges", ["sprint_id"], name: "index_sprint_badges_on_sprint_id", using: :btree

  create_table "sprint_badges_users", id: false, force: :cascade do |t|
    t.integer "sprint_badge_id", limit: 4, null: false
    t.integer "user_id",         limit: 4, null: false
  end

  create_table "sprint_pages", force: :cascade do |t|
    t.integer  "sprint_id",  limit: 4
    t.integer  "page_id",    limit: 4
    t.integer  "points",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "sprint_pages", ["page_id"], name: "fk_rails_8890087a83", using: :btree
  add_index "sprint_pages", ["sprint_id"], name: "fk_rails_c85ff44138", using: :btree

  create_table "sprint_soft_skills", force: :cascade do |t|
    t.integer  "sprint_id",     limit: 4
    t.integer  "soft_skill_id", limit: 4
    t.decimal  "points",                  precision: 11, scale: 2
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "sprint_users", force: :cascade do |t|
    t.integer  "sprint_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.boolean  "jedi",       limit: 1, default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "sprint_users", ["sprint_id"], name: "index_sprint_users_on_sprint_id", using: :btree
  add_index "sprint_users", ["user_id"], name: "index_sprint_users_on_user_id", using: :btree

  create_table "sprints", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.integer  "group_id",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "sequence",    limit: 4
  end

  add_index "sprints", ["group_id"], name: "index_sprints_on_group_id", using: :btree

  create_table "submissions", force: :cascade do |t|
    t.integer  "page_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.string   "link",       limit: 255
    t.decimal  "points",                 precision: 11, scale: 2
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "submissions", ["page_id"], name: "index_submissions_on_page_id", using: :btree
  add_index "submissions", ["user_id"], name: "index_submissions_on_user_id", using: :btree

  create_table "surveys", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "introduction", limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "tech_related_activities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "description",       limit: 65535
    t.string   "syllabus",          limit: 255
    t.string   "color",             limit: 255
    t.string   "icon_file_name",    limit: 255
    t.string   "icon_content_type", limit: 255
    t.integer  "icon_file_size",    limit: 4
    t.datetime "icon_updated_at"
    t.integer  "sequence",          limit: 4
  end

  create_table "units", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "description", limit: 255
    t.integer  "course_id",   limit: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "sequence",    limit: 4,   default: 0
    t.integer  "points",      limit: 4
    t.integer  "duration",    limit: 4
  end

  add_index "units", ["course_id"], name: "index_units_on_course_id", using: :btree

  create_table "user_authentications", force: :cascade do |t|
    t.integer  "user_id",                    limit: 4
    t.integer  "authentication_provider_id", limit: 4
    t.string   "uid",                        limit: 255
    t.string   "token",                      limit: 255
    t.datetime "token_expires_at"
    t.text     "params",                     limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "user_authentications", ["authentication_provider_id"], name: "index_user_authentications_on_authentication_provider_id", using: :btree
  add_index "user_authentications", ["user_id"], name: "index_user_authentications_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: ""
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "code",                   limit: 255
    t.boolean  "disable",                limit: 1,   default: false
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
    t.integer  "role",                   limit: 4,   default: 0
    t.integer  "group_id",               limit: 4
    t.integer  "recomended_as",          limit: 4,   default: 0
    t.boolean  "hire",                   limit: 1,   default: false
  end

  add_index "users", ["code"], name: "index_users_on_code", unique: true, using: :btree
  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "answers", "attempts"
  add_foreign_key "answers", "questions"
  add_foreign_key "attempts", "surveys"
  add_foreign_key "attempts", "users"
  add_foreign_key "courses", "tracks"
  add_foreign_key "districts", "branches"
  add_foreign_key "educations", "branches"
  add_foreign_key "enrollments", "tracks"
  add_foreign_key "enrollments", "users"
  add_foreign_key "family_incomes", "branches"
  add_foreign_key "groups", "branches"
  add_foreign_key "job_salaries", "branches"
  add_foreign_key "lessons", "units"
  add_foreign_key "page_visibilities", "branches"
  add_foreign_key "page_visibilities", "pages"
  add_foreign_key "pages", "lessons"
  add_foreign_key "profiles", "districts"
  add_foreign_key "profiles", "educations"
  add_foreign_key "profiles", "family_incomes"
  add_foreign_key "profiles", "job_salaries"
  add_foreign_key "profiles", "semesters_lefts"
  add_foreign_key "profiles", "spots"
  add_foreign_key "profiles", "users"
  add_foreign_key "questions", "surveys"
  add_foreign_key "semesters_lefts", "branches"
  add_foreign_key "soft_skill_submissions", "soft_skills"
  add_foreign_key "soft_skill_submissions", "sprints"
  add_foreign_key "soft_skill_submissions", "users"
  add_foreign_key "spots", "branches"
  add_foreign_key "sprint_badges", "badges"
  add_foreign_key "sprint_badges", "sprints"
  add_foreign_key "sprint_pages", "pages"
  add_foreign_key "sprint_pages", "sprints"
  add_foreign_key "sprint_users", "sprints"
  add_foreign_key "sprint_users", "users"
  add_foreign_key "sprints", "groups"
  add_foreign_key "units", "courses"
  add_foreign_key "users", "groups"
end
