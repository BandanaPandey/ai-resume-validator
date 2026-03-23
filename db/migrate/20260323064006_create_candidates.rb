class CreateCandidates < ActiveRecord::Migration[8.1]
  def change
    create_table :candidates do |t|
      t.string :name
      t.text :resume_text
      t.timestamps
    end
  end
end
