class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :survey, index: true, foreign_key: true
      t.references :sprint, index: true, foreign_key: true
      t.string  :question_type
      t.string :question_text
      t.integer :position
      t.text :answer_options
      t.string :min_label
      t.string :max_label
      t.integer :jedi
      t.references :question

      t.timestamps null: false
    end
  end
end
