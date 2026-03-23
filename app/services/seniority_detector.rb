# app/services/seniority_detector.rb
class SeniorityDetector
  def initialize(text)
    @text = text.downcase
  end

  def level
    return "senior" if @text.match?(/senior|lead|architect/)
    return "mid" if @text.match?(/3\s+years|4\s+years|5\s+years/)
    return "junior"
  end
end