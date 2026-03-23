# app/services/keyword_matcher.rb
class KeywordMatcher
  def initialize(resume, job)
    @resume = resume.downcase
    @job = job.downcase
  end

  def score
    job_keywords = extract_keywords(@job)
    return 0 if job_keywords.empty?

    matches = job_keywords.count { |kw| @resume.include?(kw) }

    ((matches.to_f / job_keywords.size) * 100).round
  end

  private

  def extract_keywords(text)
    text.scan(/\b[a-z]{4,}\b/).uniq
  end
end