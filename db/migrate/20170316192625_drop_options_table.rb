class DropOptionsTable < ActiveRecord::Migration
  def up
    drop_table :options
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
