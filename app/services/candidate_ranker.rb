class CandidateRanker
  def initialize(job_description:, candidates:, provider: nil)
    @job_description = job_description
    @candidates = candidates
    @provider = provider
  end

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

    #score = CandidateScoreCalculator.new(gap).score
    score = gap[:smart_score]
    score_breakdown = gap[:score_breakdown]

    {
      candidate_id: candidate[:id],
      score: score,
      score_breakdown: score_breakdown,
      summary: build_summary(gap),
      details: gap
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
  # Smart Summary
  #########################################
  def build_summary(gap)
    if gap[:missing_critical_skills].any?
      "Missing critical skills: #{gap[:missing_critical_skills].join(', ')}"
    elsif gap[:weak_matched_skills].any?
      "Has skills but weak in: #{gap[:weak_matched_skills].join(', ')}"
    else
      "Strong match for this role"
    end
  end
end