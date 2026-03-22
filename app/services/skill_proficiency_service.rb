# app/services/skill_proficiency_service.rb
class SkillProficiencyService
  def initialize(text, skills, provider: nil)
    @text = text
    @skills = skills
    @provider = provider
  end

  def call
    rule_based = rule_proficiency
    llm_based = llm_proficiency

    merge(rule_based, llm_based)
  end

  private

  #########################################
  # Rule-Based
  #########################################
  def rule_proficiency
    SkillProficiencyDetector
      .new(@text)
      .detect(@skills)
  end

  #########################################
  # LLM-Based
  #########################################
  def llm_proficiency
    return [] unless @provider

    LlmSkillProficiencyService
      .new(@text, @skills, provider: @provider)
      .call
  end

  #########################################
  # Merge Logic
  #########################################
  def merge(rule_based, llm_based)
    llm_map = llm_based.index_by { |s| s["skill"] }

    rule_based.map do |rule|
      llm = llm_map[rule[:skill]]

      if llm
        {
          skill: rule[:skill],
          level: llm["level"],
          score: llm["score"],
          reason: llm["reason"],
          source: "llm",
          fallback_score: rule[:score]
        }
      else
        rule
      end
    end
  end
end