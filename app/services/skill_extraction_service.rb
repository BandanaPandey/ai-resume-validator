# app/services/skill_extraction_service.rb
class SkillExtractionService
  def initialize(content, provider: nil)
    @content = content
    @provider = Llm::Providers::ProviderFactory.build(provider)
  end

  def extract
    prompt = Prompts::SkillExtractionPromptBuilder.new(@content).build

    result = @provider.analyze_resume(prompt)

    normalize(result)
  end

  private

  def normalize(result)
    {
      technical_skills: result[:technical_skills] || [],
      soft_skills: result[:soft_skills] || [],
      tools: result[:tools] || [],
      frameworks: result[:frameworks] || []
    }
  end
end