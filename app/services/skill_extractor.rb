class SkillExtractor
  SKILL_DICTIONARY = {
    technical: %w[
      ruby python java javascript typescript sql mysql postgres mongodb redis graphql rest api
    ],
    frameworks: %w[
      rails react angular vue nextjs django flask spring express
    ],
    tools: %w[
      docker kubernetes aws gcp azure git github gitlab jira terraform
    ],
    soft_skills: %w[
      communication leadership teamwork problem-solving adaptability ownership
    ]
  }

  SYNONYMS = {
    "ruby on rails" => "rails",
    "restful api" => "api",
    "postgresql" => "postgres",
    "js" => "javascript"
  }

  def initialize(text)
    @text = normalize(text.to_s.downcase)
  end

  def call
    result = {}

    SKILL_DICTIONARY.each do |category, skills|
      result[category] = skills.select do |skill|
        match?(skill)
      end
    end

    result[:all] = result.values.flatten.uniq
    result
  end

  private

  def normalize(text)
    SYNONYMS.each do |k, v|
      text.gsub!(k, v)
    end
    text
  end

  def match?(skill)
    !!(@text =~ /\b#{Regexp.escape(skill)}\b/)
  end
end