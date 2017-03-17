class DropQuestionGroupsTable < ActiveRecord::Migration
  def up
    drop_table :question_groups
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
