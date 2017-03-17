class DropQuestionsTable < ActiveRecord::Migration
  def up
    drop_table :questions
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
