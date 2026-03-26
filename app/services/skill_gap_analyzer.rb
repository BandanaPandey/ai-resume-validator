class SkillGapAnalyzer
  CRITICAL_WEIGHT_THRESHOLD = 0.75
  LOW_SEMANTIC_THRESHOLD = 0.4
  MID_SEMANTIC_THRESHOLD = 0.65

  def initialize(resume_text:, job_description:, provider: nil)
    @resume_text = resume_text
    @job_description = job_description
    @provider = provider
  end

  def call
    # 🔹 Extract skills
    resume_skills = extract(@resume_text)
    job_skills = extract(@job_description)

     # 🔹 Semantic matching
    matcher = SemanticSkillMatcher.new(provider: @provider)
    semantic_result = matcher.match(resume_skills, job_skills)

    # 🔥 Proficiency (HYBRID)
    proficiency = SkillProficiencyService.new(
      @resume_text,
      resume_skills
    ).call

    # 🔥 NEW: Job weighting
    weights = JobSkillWeighter.new(@job_description).weight(job_skills)

    matched_skills = semantic_result[:matched].map { |m| m[:job_skill] }
    missing_skills = semantic_result[:missing]

    # 🔹 Scores
    match_score = basic_score(semantic_result[:matched], job_skills)
    weighted_score = calculate_weighted_score(weights, semantic_result)

    weak_skills = weak_matched_skills(proficiency, semantic_result)
    critical_skills = critical_missing(weights, semantic_result, proficiency)

    smart_score = SmartScoreService.new(
      {
        weighted_score: weighted_score,
        proficiency: proficiency,
        missing_critical_skills: critical_skills,
        weak_matched_skills: weak_skills
      },
      @resume_text,
      @job_description
    ).compute

    {
      match_score: match_score,
      weighted_score: weighted_score,
      matched_skills: matched_skills,
      missing_skills: missing_skills,
      semantic_matches: semantic_result[:matched],
      proficiency: proficiency,
      weak_matched_skills: weak_skills,
      missing_critical_skills: critical_skills,
      breakdown: build_breakdown(weights, semantic_result),
      smart_score: smart_score[:final_score],
      score_breakdown: smart_score[:components],
      recommendations: build_recommendations(semantic_result, proficiency, weights)
    }
  end

  private

  #########################################
  # Extract Skills
  #########################################
  def extract(text)
    SkillExtractionService.new(text, provider: @provider).extract[:all]
  end

  #########################################
  # Basic Score
  #########################################
  def basic_score(matched, total)
    return 0 if total.empty?
    ((matched.size.to_f / total.size) * 100).round
  end

  #########################################
  # Weighted Score
  #########################################
  def calculate_weighted_score(weights, semantic)
    total_weight = weights.sum { |w| w[:weight] }

    matched_skills = semantic[:matched].map { |m| m[:job_skill] }

    matched_weight = weights
      .select { |w| matched_skills.include?(w[:skill]) }
      .sum { |w| w[:weight] }

    return 0 if total_weight.zero?

    ((matched_weight / total_weight) * 100).round
  end

  #########################################
  # Weak Matched Skills
  #########################################
  def weak_matched_skills(proficiency, semantic)
    semantic[:matched].filter_map do |m|
      prof = proficiency.find { |p| p[:skill] == m[:resume_skill] }

      next unless prof

      if m[:score] < 0.7 || %w[beginner intermediate].include?(prof[:level])
        {
          skill: m[:job_skill],
          resume_skill: m[:resume_skill],
          score: m[:score].round(2),
          level: prof[:level],
          reason: build_weak_reason(m[:score], prof[:level])
        }
      end
    end
  end

  #########################################
  # Critical Missing Skills
  #########################################
  def critical_missing(weights, semantic, proficiency)
    missing = semantic[:missing]

    missing.filter_map do |skill|
      weight = weights.find { |w| w[:skill] == skill }&.dig(:weight) || 0.5

      semantic_score = best_semantic_score(skill, semantic)
      prof = related_proficiency(skill, proficiency)

      if critical?(weight, semantic_score, prof)
        {
          skill: skill,
          weight: weight.round(2),
          semantic_score: semantic_score.round(2),
          proficiency: prof,
          reason: build_critical_reason(weight, semantic_score, prof)
        }
      end
    end
  end

  #########################################
  def best_semantic_score(skill, semantic)
    semantic[:matched]
      .select { |m| m[:job_skill] == skill }
      .map { |m| m[:score] }
      .max || 0.0
  end

  #########################################
  def related_proficiency(skill, proficiency)
    match = proficiency.find { |p| p[:skill].include?(skill) }
    match&.dig(:level)
  end

  #########################################
  def critical?(weight, semantic_score, prof)
    return false if weight < CRITICAL_WEIGHT_THRESHOLD

    return true if semantic_score < LOW_SEMANTIC_THRESHOLD

    if semantic_score < MID_SEMANTIC_THRESHOLD
      return true if %w[beginner intermediate].include?(prof)
    end

    false
  end

  #########################################
  def build_critical_reason(weight, semantic_score, prof)
    reasons = []
    reasons << "High importance (#{weight})"
    reasons << (semantic_score < 0.4 ? "No/low semantic match" : "Partial match")
    reasons << "Low proficiency (#{prof})" if prof
    reasons.join(" + ")
  end

  #########################################
  def build_weak_reason(score, level)
    reasons = []
    reasons << "Low semantic match" if score < 0.7
    reasons << "Low proficiency (#{level})" if %w[beginner intermediate].include?(level)
    reasons.join(" + ")
  end

  #########################################
  # Breakdown for UI
  #########################################
  def build_breakdown(weights, semantic)
    matched = semantic[:matched].map { |m| m[:job_skill] }

    weights.map do |w|
      {
        skill: w[:skill],
        weight: w[:weight],
        matched: matched.include?(w[:skill])
      }
    end
  end

  #########################################
  # Smart Recommendations
  #########################################
  def build_recommendations(semantic, proficiency, weights)
    recommendations = []

     # Missing skills
    semantic[:missing].each do |skill|
      recommendations << "Add #{skill} if you have experience"
    end

    # Weak skills
    proficiency.each do |p|
      if %w[beginner intermediate].include?(p[:level])
        recommendations << "Improve #{p[:skill]} (#{p[:level]})"
      end
    end

    # Critical missing
    critical_missing(weights, semantic, proficiency).each do |s|
      recommendations << "🔥 PRIORITY: Learn #{s[:skill]} (#{s[:reason]})"
    end

    recommendations.uniq
  end
end