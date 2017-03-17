class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :attempt, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true
      t.text :answer_text

      t.timestamps null: false
    end
  end
end
