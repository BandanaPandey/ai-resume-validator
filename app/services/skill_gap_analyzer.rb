class SkillGapAnalyzer
  def initialize(resume_text:, job_description:, provider: nil)
    @resume_text = resume_text
    @job_description = job_description
    @provider = provider
  end

  def call
    resume_skills = extract(@resume_text)
    job_skills = extract(@job_description)

    puts "Extracted Resume Skills: #{resume_skills.inspect}"
    puts "Extracted Job Description Skills: #{job_skills.inspect}"

    matched = resume_skills & job_skills
    missing = job_skills - resume_skills
    extra   = resume_skills - job_skills

    {
      match_score: calculate_score(matched, job_skills),
      matched_skills: matched,
      missing_skills: missing,
      extra_skills: extra,
      recommendations: build_recommendations(missing)
    }
  end

  private

  def extract(text)
    SkillExtractionService
      .new(text, provider: @provider)
      .extract[:all]
  end

  def calculate_score(matched, total)
    return 0 if total.empty?
    ((matched.size.to_f / total.size) * 100).round
  end

  def build_recommendations(missing)
    missing.map do |skill|
      "Add #{skill} to your resume if you have experience"
    end
  end
end