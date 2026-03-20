class CreateSkills < ActiveRecord::Migration[8.1]
  def change
    enable_extension "vector"
     
    create_table :skills do |t|
      t.string :name
      #t.vector :embedding, limit: 1536  # OpenAI size

      t.timestamps
    end

    #add_index :skills, :embedding, using: :ivfflat, opclass: :vector_cosine_ops
  end
end
