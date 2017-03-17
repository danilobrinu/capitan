class DropAnswersTable < ActiveRecord::Migration
  def up
    drop_table :answers
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
