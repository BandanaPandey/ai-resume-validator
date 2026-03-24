# app/services/skill_embedding_service.rb
class SkillEmbeddingService
  def initialize(provider:)
    @provider = Embeddings::Providers::ProviderFactory.build(provider)
    @cache = {}
  end

  #########################################
  # MAIN METHOD
  #########################################
  def embed(text)
    return [] if text.blank?

    key = normalize(text)

    # 🔥 Cache to avoid repeated API calls
    @cache[key] ||= begin
      vector = @provider.embed(key)

      validate!(vector)

      vector
    end
  end

  #########################################
  # Optional: store in DB
  #########################################
  def find_or_create(skill_name)
    skill = Skill.find_by(name: skill_name.downcase)

    return skill if skill&.embedding.present?

    embedding = embed(skill_name)

    Skill.create!(
      name: skill_name.downcase,
      embedding: to_pgvector(embedding)
    )
  end

  private

  #########################################
  def normalize(text)
    text.to_s.downcase.strip
  end

  #########################################
  def validate!(vector)
    unless vector.is_a?(Array) && vector.all? { |v| v.is_a?(Numeric) }
      raise "Invalid embedding format"
    end

    # 🔥 IMPORTANT: enforce dimension
    expected_dim = 768  # or 1536 depending on model

    if vector.size != expected_dim
      raise "Embedding dimension mismatch: expected #{expected_dim}, got #{vector.size}"
    end
  end

  #########################################
  def to_pgvector(array)
    "[#{array.join(',')}]"
  end
end