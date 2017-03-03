class CreateSprintUsers < ActiveRecord::Migration
  def change
    create_table :sprint_users do |t|
      t.references :sprint, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :jedi, default: false

      t.timestamps null: false
    end
  end
end
