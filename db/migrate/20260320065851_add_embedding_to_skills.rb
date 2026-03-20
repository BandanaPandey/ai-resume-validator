class AddEmbeddingToSkills < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      ALTER TABLE skills
      ADD COLUMN embedding vector(768);
    SQL

    execute <<~SQL
      CREATE INDEX index_skills_on_embedding
      ON skills
      USING ivfflat (embedding vector_cosine_ops)
      WITH (lists = 100);
    SQL
  end

  def down
    execute "DROP INDEX IF EXISTS index_skills_on_embedding;"
    remove_column :skills, :embedding
  end
end
