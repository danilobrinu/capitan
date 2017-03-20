class CreateJoinTableQuestionSprintUser < ActiveRecord::Migration
  def change
    create_join_table :questions, :sprint_users do |t|
       t.index [:question_id, :sprint_user_id]
       t.index [:sprint_user_id, :question_id]
    end
  end
end
