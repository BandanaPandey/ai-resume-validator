# app/services/candidate_comparison_service.rb
class CandidateComparisonService
  def initialize(candidates:,job_description:, provider:)
    @candidates = candidates
    @job_description = job_description
    @provider = Llm::Providers::ProviderFactory.build(provider)
  end

  def call
    prompt = build_prompt
    response = @provider.compare_candidates(prompt)
    return {"summary" => "Failed to generate summary"} unless response.is_a?(Hash)
    response["response"] || fallback_summary

    #response[:text] || "Unable to generate summary"
  rescue => e
    Rails.logger.error("Comparison failed: #{e.message}")
    fallback_summary
  end

  private

  def build_prompt
    <<~PROMPT
    You are an ATS AI assistant.

    JOB DESCRIPTION:
    #{@job_description}

    Compare the following candidates specifically for this job.

    Provide:
    1. Strengths of each candidate relative to the job
    2. Weaknesses / missing critical skills
    3. Who is the best fit and why
    4. Final recommendation (clear decision)

    Candidates:
    #{formatted_candidates}

    Keep it concise, factual, and recruiter-friendly.
    PROMPT
  end

  def formatted_candidates
    @candidates.map do |c|
      <<~TEXT
      Candidate #{c[:candidate_id]}:
      Score: #{c[:score]}
      Matched Skills: #{c.dig(:details, :matched_skills)&.join(", ")}
      Missing Skills: #{c.dig(:details, :missing_skills)&.join(", ")}
      Weak Skills: #{c.dig(:details, :weak_matched_skills)&.join(", ")}
      TEXT
    end.join("\n")
  end

#   def formatted_candidates
#     @candidates.map do |c|
#       <<~TEXT
#       Candidate #{c[:candidate_id]}:
#       Score: #{c[:score]}
#       Matched Skills: #{c.dig(:details, :matched_skills)&.join(", ")}
#       Missing Skills: #{c.dig(:details, :missing_skills)&.join(", ")}
#       Critical Missing: #{format_critical(c)}
#       Weak Skills: #{c.dig(:details, :weak_matched_skills)&.join(", ")}
#       TEXT
#     end.join("\n")
#   end

#   #########################################
#   def format_critical(candidate)
#     (candidate.dig(:details, :missing_critical_skills) || [])
#       .map { |s| s[:skill] }
#       .join(", ")
#   end


  def fallback_summary
    "Top candidate is ##{@candidates.max_by { |c| c[:score] }[:candidate_id]} based on score."
  end
end