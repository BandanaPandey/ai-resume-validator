class SkillExtractionService
  def initialize(content, provider: nil)
    @content = content.to_s
    @provider = Llm::Providers::ProviderFactory.build(provider)
  end

  def extract
    ai_result = extract_with_ai
    puts "AI Extraction Result: #{ai_result.inspect}"
    keyword_result = extract_with_dictionary
    puts "Keyword Extraction Result: #{keyword_result.inspect}"

    merged = merge_results(ai_result, keyword_result)

    normalize(merged)
  end

  private

  #########################################
  # 🤖 AI Extraction
  #########################################
  def extract_with_ai
    return {} unless @provider

    prompt = Prompts::SkillExtractionPromptBuilder
               .new(@content)
               .build

    response = @provider.analyze_resume(prompt)

    symbolize_keys(response)
  rescue => e
    Rails.logger.error("AI Skill Extraction failed: #{e.message}")
    {}
  end

  #########################################
  # ⚡ Fallback: Dictionary Extraction
  #########################################
  def extract_with_dictionary
    SkillExtractor.new(@content).call
  end

  #########################################
  # 🔀 Merge AI + Keyword
  #########################################
  def merge_results(ai, keyword)
    categories = [:technical_skills, :soft_skills, :tools, :frameworks]

    result = {}

    categories.each do |category|
      ai_vals = ai[category] || []
      keyword_vals = map_dictionary_keys(keyword, category)

      result[category] = SkillNormalizer.normalize_list(ai_vals + keyword_vals)
    end

    result
  end

  # #########################################
  # # 🧹 Normalize Final Output
  # #########################################
  # def normalize(result)
  #   all_skills = result.values.flatten.uniq

  #   {
  #     technical_skills: result[:technical_skills] || [],
  #     soft_skills: result[:soft_skills] || [],
  #     tools: result[:tools] || [],
  #     frameworks: result[:frameworks] || [],
  #     all: all_skills
  #   }
  # end
  #########################################
  # 🧹 Normalize + Deduplicate Final Output
  #########################################
  def normalize(result)
    # Step 1: Normalize each category
    normalized = {}

    result.each do |category, skills|
      normalized[category] = SkillNormalizer.normalize_list(skills)
    end

    # Step 2: Deduplicate within each category
    normalized.each do |category, skills|
      normalized[category] = skills.uniq
    end

    # Step 3: Cross-category flatten
    all_skills = normalized.values.flatten.uniq

    # Step 4: Semantic deduplication (optional but powerful)
    deduplicator = SemanticDeduplicator.new()
    all_skills = deduplicator.deduplicate(all_skills)

    # Step 5: Re-map categories after semantic dedup
    categorized = {
      technical_skills: [],
      soft_skills: [],
      tools: [],
      frameworks: []
    }

    all_skills.each do |skill|
      categorized[:technical_skills] << skill if SkillExtractor::SKILL_DICTIONARY[:technical].include?(skill)
      categorized[:frameworks] << skill if SkillExtractor::SKILL_DICTIONARY[:frameworks].include?(skill)
      categorized[:tools] << skill if SkillExtractor::SKILL_DICTIONARY[:tools].include?(skill)
      categorized[:soft_skills] << skill if SkillExtractor::SKILL_DICTIONARY[:soft_skills].include?(skill)
    end

    categorized[:all] = all_skills

    categorized
  end

  #########################################
  # 🔧 Helpers
  #########################################
  def symbolize_keys(hash)
    return {} unless hash.is_a?(Hash)
    hash.transform_keys { |k| k.to_sym rescue k }
  end

  def map_dictionary_keys(keyword, category)
    case category
    when :technical_skills
      keyword[:technical] || []
    when :soft_skills
      keyword[:soft_skills] || []
    when :tools
      keyword[:tools] || []
    when :frameworks
      keyword[:frameworks] || []
    else
      []
    end
  end
end