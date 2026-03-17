# app/services/prompts/resume_prompt_builder.rb
class Prompts::ResumePromptBuilder
  def initialize(content, job_description: nil)
    @content = content
    @job_description = job_description
  end

  def build
    <<~PROMPT
      You are an expert resume reviewer and ATS system.

      Evaluate the resume strictly and objectively.

      SCORING CRITERIA (0–100):

      1. ATS Compatibility (20%)
      - Proper formatting
      - No tables/images
      - Standard sections

      2. Content Quality (25%)
      - Strong action verbs
      - No fluff
      - Clear impact

      3. Quantification (20%)
      - Metrics, numbers, results

      4. Skills Relevance (20%)
      - Relevant technical & soft skills

      5. Structure & Clarity (15%)
      - Easy to read
      - Logical sections

      #{job_section}

      OUTPUT FORMAT (STRICT JSON ONLY):

      {
        "overall_score": number,
        "section_scores": {
          "ats": number,
          "content": number,
          "quantification": number,
          "skills": number,
          "structure": number
        },
        "strengths": [string],
        "weaknesses": [string],
        "improvements": [string],
        "rewritten_bullets": [
          {
            "original": string,
            "improved": string
          }
        ]
      }

      IMPORTANT:
      - Be strict (do NOT give high scores easily)
      - Return ONLY JSON (no explanation text)
      - If resume is weak, score accordingly

      RESUME:
      #{@content}
    PROMPT
  end

  private

  def job_section
    return "" unless @job_description

    <<~JOB
      JOB DESCRIPTION:
      #{@job_description}

      Also evaluate:
      - Skill match with job
      - Missing keywords
    JOB
  end
end