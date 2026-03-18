# app/services/prompts/skill_extraction_prompt_builder.rb
class Prompts::SkillExtractionPromptBuilder
  def initialize(content)
    @content = content
  end

  def build
    <<~PROMPT
      You are an expert resume parser.

      Extract all skills from the resume.

      Categorize them into:
      - technical_skills
      - soft_skills
      - tools
      - frameworks

      OUTPUT STRICT JSON:

      {
        "technical_skills": [string],
        "soft_skills": [string],
        "tools": [string],
        "frameworks": [string]
      }

      RULES:
      - Do not hallucinate skills
      - Only extract what is explicitly or strongly implied
      - Return ONLY JSON

      RESUME:
      #{@content}
    PROMPT
  end
end