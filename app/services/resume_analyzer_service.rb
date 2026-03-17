class ResumeAnalyzerService
  def initialize(content, provider: nil, job_description: nil)
    @content = content
    @provider = Providers::ProviderFactory.build(provider)
    @job_description = job_description
  end

  def analyze
    prompt = Prompts::ResumePromptBuilder.new(
      @content,
      job_description: @job_description
    ).build

    result = @provider.analyze_resume(prompt)

    normalize(result)
  end

  private

  def normalize(result)
    {
      score: result[:overall_score] || 0,
      section_scores: result[:section_scores] || {},
      strengths: result[:strengths] || [],
      weaknesses: result[:weaknesses] || [],
      improvements: result[:improvements] || [],
      rewritten_bullets: result[:rewritten_bullets] || []
    }
  end
end