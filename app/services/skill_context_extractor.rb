# app/services/skill_context_extractor.rb
class SkillContextExtractor
  WINDOW = 2

  def initialize(text)
    @sentences = split_sentences(text)
  end

  def context_for(skill)
    matches = []

    @sentences.each_with_index do |sentence, i|
      if sentence.downcase.include?(skill)
        window = @sentences[[i - WINDOW, 0].max..i + WINDOW]
        matches << window.join(" ")
      end
    end

    matches.join(" ")
  end

  private

  def split_sentences(text)
    text.to_s.split(/[\.\n]/).map(&:strip).reject(&:empty?)
  end
end