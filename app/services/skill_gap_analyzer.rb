class SkillGapAnalyzer
  def initialize(resume_text:, job_description:, provider: nil)
    @resume_text = resume_text
    @job_description = job_description
    @provider = provider
  end

  def call
    resume_skills = extract(@resume_text)
    job_skills = extract(@job_description)

    matcher = SemanticSkillMatcher.new(provider: @provider)
    semantic_result = matcher.match(resume_skills, job_skills)

    matched_skills = semantic_result[:matched].map { |m| m[:job_skill] }
    missing_skills = semantic_result[:missing]

    {
      match_score: calculate_score(matched_skills, job_skills),
      matched_skills: matched_skills,
      missing_skills: missing_skills,
      semantic_matches: semantic_result[:matched],
      recommendations: build_recommendations(missing_skills)
    }
  end

  private

  def extract(text)
    SkillExtractionService.new(text, provider: @provider).extract[:all]
  end

  def calculate_score(matched, total)
    return 0 if total.empty?
    ((matched.size.to_f / total.size) * 100).round
  end

  def build_recommendations(missing)
    missing.map { |s| "Add #{s} if you have experience" }
  end
end