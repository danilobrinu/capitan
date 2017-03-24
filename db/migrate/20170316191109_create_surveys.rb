class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.text :introduction
      t.boolean :single_attempt

      t.timestamps null: false
    end
  end
end
