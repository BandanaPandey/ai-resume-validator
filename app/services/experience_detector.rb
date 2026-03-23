# app/services/experience_detector.rb
class ExperienceDetector
  def initialize(text)
    @text = text.downcase
  end

  def years
    matches = @text.scan(/(\d+)\+?\s*(years|yrs)/)
    return 0 if matches.empty?

    matches.map { |m| m[0].to_i }.max
  end
end