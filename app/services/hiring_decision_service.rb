class HiringDecisionService
  def initialize(gap:, score:)
    @gap = gap
    @score = score
  end

  #########################################
  # MAIN
  #########################################
  def call
    {
      decision: decision,
      confidence: confidence,
      reasons: reasons
    }
  end

  private

  #########################################
  # 🎯 FINAL DECISION
  #########################################
  def decision
    return "Reject" if reject?

    return "Strong Hire" if strong_hire?

    return "Hire" if hire?

    "Weak Hire"
  end

  #########################################
  # RULES
  #########################################
  def reject?
    @score < 40 ||
      critical_count >= 3
  end

  def strong_hire?
    @score >= 80 &&
      critical_count == 0 &&
      weak_count <= 2
  end

  def hire?
    @score >= 60 &&
      critical_count <= 1
  end

  #########################################
  # SIGNAL HELPERS
  #########################################
  def critical_count
    (@gap[:missing_critical_skills] || []).size
  end

  def weak_count
    (@gap[:weak_matched_skills] || []).size
  end

  #########################################
  # 📊 CONFIDENCE SCORE
  #########################################
  def confidence
    base = @score

    base -= critical_count * 10
    base -= weak_count * 3

    [[base, 0].max, 100].min
  end

  #########################################
  # 🧠 EXPLAINABILITY
  #########################################
  def reasons
    r = []

    if critical_count > 0
      r << "Missing critical skills (#{critical_count})"
    end

    if weak_count > 0
      r << "Weak skill areas (#{weak_count})"
    end

    if strong_skills.any?
      r << "Strong proficiency in #{strong_skills.join(', ')}"
    end

    r << "Overall score: #{@score}"

    r
  end

  #########################################
  def strong_skills
    (@gap[:proficiency] || [])
      .select { |p| %w[advanced expert].include?(p[:level]) }
      .map { |p| p[:skill] }
      .first(3)
  end
end