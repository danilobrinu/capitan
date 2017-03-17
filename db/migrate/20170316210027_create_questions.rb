class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :survey, index: true, foreign_key: true
      t.string :question_text
      t.integer :position
      t.integer :min_value
      t.integer :max_value

      t.timestamps null: false
    end
  end
end
