class SkillNormalizer
  GLOBAL_SYNONYMS = {
    "ruby on rails" => "rails",
    "ror" => "rails",
    "reactjs" => "react",
    "react.js" => "react",
    "nodejs" => "node",
    "node.js" => "node",
    "postgresql" => "postgres",
    "js" => "javascript",
    "ts" => "typescript",
    "restful api" => "api"
  }

  def self.normalize(skill)
    return "" if skill.blank?

    s = skill.to_s.downcase.strip

    # Apply global synonyms
    GLOBAL_SYNONYMS.each do |k, v|
      s.gsub!(k, v)
    end

    # Remove noise
    s.gsub!(/[^a-z0-9\s\.\+#]/, "")
    s.gsub!(/\s+/, " ")

    s.strip
  end

  def self.normalize_list(skills)
    skills
      .map { |s| normalize(s) }
      .reject(&:blank?)
      .uniq
  end
end