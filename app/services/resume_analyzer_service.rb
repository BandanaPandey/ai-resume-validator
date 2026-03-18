class ResumeAnalyzerService
  def initialize(content, provider: nil, job_description: nil)
    @content = content
    @provider_name = provider
    @job_description = job_description
  end

  def analyze
    # Step 1: Extract skills
    skills = SkillExtractionService.new(
      @content,
      provider: @provider_name
    ).extract
    
    # Step 2: Build enriched prompt
    prompt = Prompts::ResumePromptBuilder.new(
      @content,
      job_description: @job_description,
      extracted_skills: skills
    ).build

    provider = Llm::Providers::ProviderFactory.build(@provider_name)
    result = provider.analyze_resume(prompt)

    normalize(result, skills)
  end

  private

  def normalize(result, skills)
    {
      score: result[:overall_score] || 0,
      section_scores: result[:section_scores] || {},
      strengths: result[:strengths] || [],
      weaknesses: result[:weaknesses] || [],
      improvements: result[:improvements] || [],
      rewritten_bullets: result[:rewritten_bullets] || [],
      extracted_skills: skills
    }
  end
end