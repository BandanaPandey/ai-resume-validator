class CreateCandidateSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :candidate_skills do |t|
      t.references :candidate
      t.references :skill

      t.string :level
      t.float :score, precision: 10, scale: 2

      t.timestamps
    end
  end
end
