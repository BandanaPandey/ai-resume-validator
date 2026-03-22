# app/services/skill_proficiency_detector.rb
class SkillProficiencyDetector
  STRONG_PATTERNS = [
    /(\d+)\+?\s*(years|yrs)/i,
    /led|architected|designed|built|owned|developed/i,
    /production|scalable|high performance/i
  ]

  MEDIUM_PATTERNS = [
    /worked with|used|implemented|integrated/i
  ]

  WEAK_PATTERNS = [
    /basic|familiar|learning|beginner/i
  ]

  def initialize(text)
    @text = text.downcase
    @context_extractor = SkillContextExtractor.new(text)
  end

  def detect(skills)
    skills.map do |skill|
      context = @context_extractor.context_for(skill)

      score, signals = score_context(context)

      {
        skill: skill,
        level: level_from_score(score),
        score: score.round(2),
        signals: signals,
        source: "rule"
      }
    end
  end

  private

  def score_context(context)
    score = 0.0
    signals = []

    STRONG_PATTERNS.each do |p|
      if context =~ p
        score += 0.4
        signals << context.match(p).to_s
      end
    end

    MEDIUM_PATTERNS.each do |p|
      if context =~ p
        score += 0.2
        signals << context.match(p).to_s
      end
    end

    WEAK_PATTERNS.each do |p|
      if context =~ p
        score -= 0.2
        signals << context.match(p).to_s
      end
    end

    score = [[score, 0].max, 1].min
    [score, signals]
  end

  def level_from_score(score)
    case score
    when 0.85..1.0 then "expert"
    when 0.65..0.84 then "advanced"
    when 0.4..0.64 then "intermediate"
    else "beginner"
    end
  end
end