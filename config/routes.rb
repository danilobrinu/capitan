Rails.application.routes.draw do

  authenticate :user do

    namespace :survey do
      get 'show/:id' => "render#show"
      post 'show/:id' => "render#saveAnswers"
    end

    namespace :employer do
      get 'dashboard/coders'
      get 'dashboard/profile/:user_id' => 'dashboard#profile', as: :student_profile
    end

    namespace :student do
      get 'dashboard/home'
      get 'dashboard/performance'
      get 'dashboard/tracks'
      get 'dashboard/resources'
      get 'tracks/:id' => 'tracks#show', as: :tracks
    end

    namespace :teacher do
      get 'dashboard' => redirect('teacher/dashboard/grades/filters')
      get 'dashboard/grades' => redirect('teacher/dashboard/grades/filters')
      get 'dashboard/class_stats'
      get 'dashboard/student_status'
      get 'dashboard/teacher_stats'
      get 'dashboard/grades/filters(/branch/:branch_id/group/:group_id/sprint/:sprint_id/lesson/:lesson_id/page/:page_id)' => 'dashboard#grades_filters', as: :dashboard_grades_filters
      match 'dashboard/grades/tech/input(/branch/:branch_id/group/:group_id/sprint/:sprint_id/lesson/:lesson_id)' => "dashboard#grades_input", via: [:get, :post], as: :grades_tech_input
      match 'dashboard/grades/softskill/input(/branch/:branch_id/group/:group_id/sprint/:sprint_id/stype/:stype)' => "dashboard#grades_softskill", via: [:get,:post], as: :grades_softskill_input
      get 'dashboard/grades_filter'
      get 'dashboard/attendance'
      get 'dashboard/student_ranking'
    end

    namespace :admin do
      resources :badges
      resources :soft_skills
      resources :questions
      resources :reviews
      resources :users, except: [:index] do
        get 'group/:group_id' => 'users#group', on: :collection
      end
      resources :sprints do
        get 'group/:group_id' => 'sprints#group_sprints', on: :collection
      end

      resources :tracks do
        resources :courses do
          resources :units do
            resources :lessons do
              resources :pages
            end
          end
        end
      end

      get 'dashboard' => 'dashboard#index', :as => :dashboard
      get 'page_visibility' => 'dashboard#page_visibility', :as => :page_visibility
      post 'save_visibility' => 'dashboard#save_visibility', :as => :save_visibility
      get 'users(/branch/:branch_id)' => 'users#index', :as => :users_index
      post 'change_user_status' => 'users#change_user_status', :as => :change_user_status
    end

    get 'tracks/:id' => 'admin/tracks#show_user_track', :as => :show_track
    get 'tracks/:track_id/courses/:id' => 'admin/courses#show_details', :as => :course_details
    get 'tracks/:track_id/courses/:course_id/units/:unit_id/lessons/:id/' => "admin/lessons#show", :as => :lesson_details
    get 'tracks/:track_id/courses/:course_id/units/:unit_id/lessons/:lesson_id/pages/:id' => "admin/pages#show", :as => :lesson_page_details


    get 'mycourses/:course_id/u/:unit_id/l/:id' => 'admin/lessons#show', :as => :mycourse_unit_lesson
    get 'mycourses/:course_id/u/:unit_id/l/:lesson_id/p/:id' => 'admin/pages#show', :as => :mycourse_unit_lesson_page
    get 'codereview' => 'profile#codereview', :as => :codereview
    get 'myprofile(/:sprint_id)' => 'profile#myprofile', :as => :myprofile
    get 'codereview' => 'profile#codereview', :as => :code_review

    post 'saveAnswer' => 'admin/pages#saveAnswer'
    post 'saveAnswers' => 'admin/pages#saveAnswers'
    post 'saveQuestion' => 'admin/pages#saveQuestion'

    get 'selection' => 'profile#selection', :as => :selection
    get 'selection_success' => 'profile#selection_success', :as => :selection_success

    root :to => 'admin/tracks#show_user_track'
  end

  get 'admission' => 'profile#admission', :as => :admission
  get 'admission_success' => 'profile#admission_success', :as => :admission_success

  devise_for :users,
   path: "",
   path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "signup"
   },
   controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
end
