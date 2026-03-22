# app/services/llm_skill_proficiency_service.rb
class LlmSkillProficiencyService
  def initialize(text, skills, provider:)
    @text = text
    @skills = skills
    @provider = provider ? Llm::Providers::ProviderFactory.build(provider) : nil
  end

  def call
    return [] unless @provider

    Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      response = @provider.chat(build_prompt)
      parse_response(response)
    end
  rescue => e
    Rails.logger.error("LLM Proficiency failed: #{e.message}")
    []
  end

  private

  def build_prompt
    <<~PROMPT
      You are an expert recruiter.

      Analyze the resume and assign proficiency levels.

      Resume:
      #{@text}

      Skills:
      #{@skills.join(", ")}

      Return JSON ONLY:
      {
        "skills": [
          {
            "skill": "react",
            "level": "advanced",
            "score": 0.8,
            "reason": "Built production apps"
          }
        ]
      }
    PROMPT
  end

  def parse_response(response)
    json = JSON.parse(response) rescue nil
    return [] unless json && json["skills"]

    json["skills"]
  end

  def cache_key
    "llm_proficiency:#{Digest::MD5.hexdigest(@text + @skills.join)}"
  end
end