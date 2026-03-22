# app/services/job_skill_weighter.rb
class JobSkillWeighter
  HIGH_PRIORITY_PATTERNS = [
    /must have/i,
    /required/i,
    /mandatory/i,
    /strong experience in/i
  ]

  MEDIUM_PRIORITY_PATTERNS = [
    /good to have/i,
    /preferred/i,
    /nice to have/i
  ]

  def initialize(job_text)
    @text = job_text.downcase
    @sentences = split_sentences(@text)
  end

  def weight(skills)
    skills.map do |skill|
      context = context_for(skill)

      weight =
        if match_any?(context, HIGH_PRIORITY_PATTERNS)
          1.0
        elsif match_any?(context, MEDIUM_PRIORITY_PATTERNS)
          0.6
        else
          base_weight(skill)
        end

      {
        skill: skill,
        weight: weight,
        context: context
      }
    end
  end

  private

  def base_weight(skill)
    # fallback logic
    if skill.length > 10
      0.7
    else
      0.5
    end
  end

  def context_for(skill)
    @sentences.find { |s| s.include?(skill) } || ""
  end

  def match_any?(text, patterns)
    patterns.any? { |p| text =~ p }
  end

  def split_sentences(text)
    text.split(/[\.\n]/).map(&:strip)
  end
end