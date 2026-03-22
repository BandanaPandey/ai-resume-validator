class SkillGapAnalyzer
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

    puts "proficiency: #{proficiency.inspect}"

    # 🔥 NEW: Job weighting
    weights = JobSkillWeighter.new(@job_description).weight(job_skills)

    matched_skills = semantic_result[:matched].map { |m| m[:job_skill] }
    missing_skills = semantic_result[:missing]

    # 🔹 Scores
    match_score = basic_score(semantic_result[:matched], job_skills)
    weighted_score = calculate_weighted_score(weights, semantic_result)

    {
      match_score: match_score,
      weighted_score: weighted_score,
      matched_skills: matched_skills,
      missing_skills: missing_skills,
      semantic_matches: semantic_result[:matched],
      proficiency: proficiency, # 🔥 NEW
      weak_matched_skills: weak_matched_skills(proficiency, semantic_result),
      missing_critical_skills: critical_missing(weights, semantic_result),
      breakdown: build_breakdown(weights, semantic_result),
      recommendations: build_recommendations(semantic_result,proficiency,weights)
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
    matched_names = semantic[:matched].map { |m| m[:resume_skill] }

    proficiency
      .select do |p|
        matched_names.include?(p[:skill]) &&
        %w[beginner intermediate].include?(p[:level])
      end
      .map { |p| p[:skill] }
  end

  #########################################
  # Critical Missing Skills
  #########################################
  def critical_missing(weights, semantic)
    missing = semantic[:missing]

    weights
      .select { |w| w[:weight] >= 0.9 && missing.include?(w[:skill]) }
      .map { |w| w[:skill] }
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
        recommendations << "Improve #{p[:skill]} (currently #{p[:level]})"
      end
    end

    # Critical missing
    critical_missing(weights, semantic).each do |skill|
      recommendations << "🔥 PRIORITY: Learn #{skill} (critical for this job)"
    end

    recommendations.uniq
  end
end