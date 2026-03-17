class CreateResumes < ActiveRecord::Migration[8.1]
  def change
    create_table :resumes do |t|
      t.string :filename
      t.text :content
      t.integer :score
      t.text :feedback

      t.timestamps
    end
  end
end
