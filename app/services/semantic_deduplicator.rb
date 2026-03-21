class SemanticDeduplicator
  THRESHOLD = 0.85

  def initialize(provider: nil)
    @provider = Embeddings::Providers::ProviderFactory.build(provider)
  end

  def deduplicate(skills)
    unique = []

    skills.each do |skill|
      unless duplicate?(skill, unique)
        unique << skill
      end
    end

    unique
  end

  private

  def duplicate?(skill, existing)
    existing.any? { |e| similar?(skill, e) }
  end

  def similar?(a, b)
    vec_a = embed(a)
    vec_b = embed(b)

    cosine(vec_a, vec_b) > THRESHOLD
  end

  def embed(skill)
    Rails.cache.fetch("embedding:#{skill}", expires_in: 7.days) do
      @provider.embed(skill)
    end
  end

  def cosine(a, b)
    dot = a.zip(b).map { |x, y| x * y }.sum
    mag_a = Math.sqrt(a.sum { |x| x**2 })
    mag_b = Math.sqrt(b.sum { |x| x**2 })

    return 0 if mag_a.zero? || mag_b.zero?

    dot / (mag_a * mag_b)
  end
end