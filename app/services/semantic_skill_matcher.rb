class SemanticSkillMatcher
  THRESHOLD = 0.75

  def initialize(provider:)
    @provider = provider
    @embedding_service = SkillEmbeddingService.new(provider: provider)
    @search = VectorSearchService.new(provider: provider) # 🔥 used for expansion
  end

  def match(resume_skills, job_skills)
    resume_embeddings = build_resume_embeddings(resume_skills)

    matched = []
    missing = []

    job_skills.each do |job_skill|
      # 🔥 Step 1: expand job skill
      expanded_skills = expand_skill(job_skill)

      best_match = nil
      best_score = -Float::INFINITY

      expanded_skills.each do |expanded|
        job_embedding = @embedding_service.embed(expanded)

        resume_embeddings.each do |resume_skill, resume_embedding|
          score = cosine_similarity(job_embedding, resume_embedding)

          if score > best_score
            best_score = score
            best_match = resume_skill
          end
        end
      end

      if best_score >= THRESHOLD
        matched << {
          job_skill: job_skill,
          resume_skill: best_match,
          score: best_score.round(3)
        }
      else
        missing << job_skill
      end
    end

    { matched: matched, missing: missing }
  end

  private

  #########################################
  # 🔥 Skill expansion using vector DB
  #########################################
  def expand_skill(skill)
    results = @search.find_similar(skill, threshold: 0.7, limit: 3)

    similar = results.map(&:name)

    ([skill] + similar).uniq
  rescue
    [skill]
  end

  #########################################
  def build_resume_embeddings(skills)
    skills.each_with_object({}) do |skill, hash|
      hash[skill] = @embedding_service.embed(skill)
    end
  end

  #########################################
  def cosine_similarity(vec1, vec2)
    dot = vec1.zip(vec2).sum { |a, b| a * b }
    mag1 = Math.sqrt(vec1.sum { |x| x**2 })
    mag2 = Math.sqrt(vec2.sum { |x| x**2 })

    return 0.0 if mag1 == 0 || mag2 == 0

    dot / (mag1 * mag2)
  end
end