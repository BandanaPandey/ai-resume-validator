class AddIndexesToJobApplications < ActiveRecord::Migration[8.1]
  def change
    add_index :job_applications, :score
    add_index :job_applications, :rank
    add_index :job_applications, :analysis, using: :gin
  end
end
