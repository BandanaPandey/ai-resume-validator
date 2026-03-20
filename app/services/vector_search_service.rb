class VectorSearchService
  def initialize(provider:)
    @provider = Embeddings::Providers::ProviderFactory.build(provider)
  end

  def find_similar(skill_name, threshold: 0.75, limit: 5)
    puts "Finding similar skills for: #{skill_name} inside VectorSearchService with provider #{@provider.class.name}"
    embedding = @provider.embed(skill_name)

    # Skill
    #   .select("skills.*, (embedding <=> '[#{embedding.join(",")}]') AS distance")
    #   .where("embedding <=> '[#{embedding.join(",")}]' < ?", (1 - threshold))
    #   .order("distance ASC")
    #   .limit(limit)
    vector = to_pgvector(embedding)

    Skill
      .select("skills.*, (embedding <=> #{vector}) AS distance")
      .where("embedding <=> #{vector} < ?", (1 - threshold))
      .order(Arel.sql("distance ASC"))
      .limit(limit)

    # Skill
    #   .select("skills.*, (embedding <=> ?::vector) AS distance", vector_str)
    #   .where("embedding <=> ?::vector < ?", vector_str, (1 - threshold))
    #   .order(Arel.sql("distance ASC"))
    #   .limit(limit)
  end

  private

  def to_pgvector(array)
    "'[#{array.join(',')}]'::vector"
  end
end