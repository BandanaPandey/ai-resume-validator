# app/services/prompts/resume_prompt_builder.rb
class Prompts::ResumePromptBuilder
  def initialize(content, job_description: nil, extracted_skills: {})
    @content = content
    @job_description = job_description
    @skills = extracted_skills
  end

  def build
    <<~PROMPT
      You are an expert resume reviewer and ATS system.

      EXTRACTED SKILLS (from resume):
      #{formatted_skills}

      Evaluate the resume strictly.

      SCORING CRITERIA:
      - ATS Compatibility
      - Content Quality
      - Quantification
      - Skills Relevance (IMPORTANT: use extracted skills)
      - Structure

      #{job_section}

      OUTPUT STRICT JSON:

      {
        "overall_score": number,
        "section_scores": {...},
        "strengths": [string],
        "weaknesses": [string],
        "improvements": [string],
        "rewritten_bullets": [...]
      }

      Return ONLY JSON.

      RESUME:
      #{@content}
    PROMPT
  end

  private

  def formatted_skills
    @skills.map do |k, v|
      "#{k}: #{v.join(", ")}"
    end.join("\n")
  end

  def job_section
    return "" unless @job_description

    <<~JOB
      JOB DESCRIPTION:
      #{@job_description}

      Compare extracted skills with job requirements.
    JOB
  end
end