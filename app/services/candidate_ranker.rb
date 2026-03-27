# app/services/candidate_ranker.rb
class CandidateRanker
  def initialize(job_description:, candidates:, provider: nil)
    @job_description = job_description
    @candidates = candidates
    @provider = provider
  end

  #########################################
  # MAIN RANK FLOW
  #########################################
  def rank
    results = @candidates.map do |candidate|
      analyze_candidate(candidate)
    end

    sorted = results.sort_by { |r| -r[:score] }

    assign_ranks(sorted)
  end

  private

  #########################################
  # Analyze Each Candidate
  #########################################
  def analyze_candidate(candidate)
    gap = SkillGapAnalyzer.new(
      resume_text: candidate[:resume],
      job_description: @job_description,
      provider: @provider
    ).call

    score = gap[:smart_score]
    score_breakdown = gap[:score_breakdown]

    decision_data = HiringDecisionService.new(
      gap: gap,
      score: score
    ).call

    {
      candidate_id: candidate[:id],
      candidate_name: candidate[:name],
      score: score,
      score_breakdown: score_breakdown,
      summary: build_summary(gap, score),
      highlights: build_highlights(gap),
      risks: build_risks(gap),
      recommendation: hiring_signal(score, gap),
      details: gap,
       # 🔥 NEW
      decision: decision_data[:decision],
      confidence: decision_data[:confidence],
      decision_reasons: decision_data[:reasons]
    }
  end

  #########################################
  # Rank Assignment
  #########################################
  def assign_ranks(results)
    results.each_with_index.map do |r, i|
      r.merge(rank: i + 1)
    end
  end

  #########################################
  # 🔥 SMART SUMMARY (MAJOR UPGRADE)
  #########################################
  def build_summary(gap, score)
    critical = gap[:missing_critical_skills] || []
    weak = gap[:weak_matched_skills] || []
    matched = gap[:matched_skills] || []

    if critical.any?
      top = critical.first

      "Strong candidate but missing critical skill '#{top[:skill]}' (#{top[:reason]}). Overall score: #{score}."
    elsif weak.any?
      weak_names = weak.map { |w| w[:skill] }.first(2).join(", ")

      "Good match with some weak areas in #{weak_names}. Overall score: #{score}."
    elsif matched.any?
      "Strong match with relevant skills aligned to job requirements. Overall score: #{score}."
    else
      "Limited alignment with job requirements. Overall score: #{score}."
    end
  end

  #########################################
  # ✅ STRENGTHS
  #########################################
  def build_highlights(gap)
    strong_skills = gap[:proficiency]
      &.select { |p| %w[advanced expert].include?(p[:level]) }
      &.map { |p| p[:skill] } || []

    matched = gap[:matched_skills] || []

    (strong_skills + matched).uniq.first(5)
  end

  #########################################
  # ⚠️ RISKS
  #########################################
  def build_risks(gap)
    risks = []

    # Critical gaps
    (gap[:missing_critical_skills] || []).each do |c|
      risks << "Missing #{c[:skill]} (#{c[:reason]})"
    end

    # Weak matches
    (gap[:weak_matched_skills] || []).each do |w|
      risks << "Weak in #{w[:skill]} (#{w[:reason]})"
    end

    risks.first(5)
  end

  #########################################
  # 🧠 HIRING SIGNAL
  #########################################
  def hiring_signal(score, gap)
    critical_count = (gap[:missing_critical_skills] || []).size

    return "Reject" if score < 40 || critical_count >= 3
    return "Weak Fit" if score < 60
    return "Consider" if score < 75
    return "Strong Hire" if critical_count.zero?

    "Hire with Reservations"
  end
end