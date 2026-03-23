class CreateJobApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :job_applications do |t|
      t.references :job
      t.references :candidate

      t.integer :rank
      t.integer :score
      t.integer :smart_score

      t.jsonb :analysis   # 🔥 full SkillGapAnalyzer response

      t.timestamps
    end

    add_index :job_applications, [:job_id, :candidate_id], unique: true
  end
end
