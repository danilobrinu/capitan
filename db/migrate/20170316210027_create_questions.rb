class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :survey, index: true, foreign_key: true
      t.string  :type
      t.string :question_text
      t.integer :position
      t.text :answer_options

      t.timestamps null: false
    end
  end
end
