class SmartScoreService
  def initialize(gap_data, resume_text, job_description)
    @gap = gap_data
    @resume = resume_text.downcase
    @job = job_description.downcase
  end

  def compute
    {
      final_score: final_score,
      components: breakdown
    }
  end

  private

  #########################################
  # FINAL SCORE
  #########################################
  def final_score
    score =
      weighted_score +
      proficiency_bonus +
      experience_score +
      keyword_score +
      impact_score -
      penalty

    normalize(score)
  end

  #########################################
  # COMPONENTS
  #########################################
  def breakdown
    {
      weighted_score: weighted_score,
      proficiency_bonus: proficiency_bonus,
      experience_score: experience_score,
      keyword_score: keyword_score,
      impact_score: impact_score,
      penalty: penalty
    }
  end

  #########################################
  def weighted_score
    @gap[:weighted_score] || 0
  end

  #########################################
  # 🔥 IMPROVED PROFICIENCY BONUS
  #########################################
  def proficiency_bonus
    return 0 unless @gap[:proficiency]

    strong = @gap[:proficiency].count { |p| %w[advanced expert].include?(p[:level]) }
    medium = @gap[:proficiency].count { |p| p[:level] == "intermediate" }

    (strong * 3) + (medium * 1)
  end

  #########################################
  def experience_score
    years = ExperienceDetector.new(@resume).years

    case years
    when 0..1 then 2
    when 2..3 then 6
    when 4..6 then 12
    else 18
    end
  end

  #########################################
  def keyword_score
    KeywordMatcher.new(@resume, @job).score * 0.3
  end

  #########################################
  def impact_score
    strong_words = %w[built scaled designed led developed architected optimized improved]

    count = strong_words.count { |w| @resume.include?(w) }

    count * 2
  end

  #########################################
  # 🔥 IMPROVED PENALTY
  #########################################
  def penalty
    critical_penalty = (@gap[:missing_critical_skills] || []).sum do |c|
      (c[:weight] * 20)
    end

    weak_penalty = (@gap[:weak_matched_skills] || []).size * 4

    (critical_penalty + weak_penalty).round
  end

  #########################################
  def normalize(score)
    [[score, 0].max, 100].min.round
  end
end