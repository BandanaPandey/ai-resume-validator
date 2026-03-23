class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.text :description
      t.string :title
      t.timestamps
    end

    add_index :jobs, :title
  end
end
