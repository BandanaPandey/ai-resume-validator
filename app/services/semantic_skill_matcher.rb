class SemanticSkillMatcher
  def initialize(provider:)
    @provider = provider
    @search = VectorSearchService.new(provider: provider)
    @embedding_service = SkillEmbeddingService.new(provider: provider)
  end

  def match(resume_skills, job_skills)
    preload_embeddings(resume_skills)

    matched = []
    missing = []

    job_skills.each do |job_skill|
    results = @search.find_similar(job_skill)
    puts "Results for '#{job_skill}': #{results.first}"

    best = results.first
    puts "Best match for '#{job_skill}': #{best&.name} with distance #{best&.distance}"

    if best && best.respond_to?(:distance) && best.distance.present?
      score = best.distance.to_f

      matched << {
        job_skill: job_skill,
        resume_skill: best.name,
        score: (1 - score).round(3)
      }
    else
      missing << job_skill
    end
  end

    { matched: matched, missing: missing }
  end

  private

  def preload_embeddings(skills)
    skills.each do |skill|
      @embedding_service.find_or_create(skill)
    end
  end
end