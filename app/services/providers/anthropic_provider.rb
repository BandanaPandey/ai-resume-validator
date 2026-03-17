# app/services/ai_providers/anthropic_provider.rb
class Providers::AnthropicProvider < Providers::BaseProvider
  def initialize
    @client = Anthropic::Client.new
  end

  def analyze_resume(prompt)
    response = @client.messages(
      model: "claude-3-haiku-20240307",
      max_tokens: 500,
      messages: [
        { role: "user", content: prompt }
      ]
    )

    text = response.dig("content", 0, "text")

    begin
      parse_json(text)
    rescue
      { score: 70, feedback: text }
    end
  end

  private

  def parse_json(text)
    json_start = text.index("{")
    json_end = text.rindex("}")

    return {} unless json_start && json_end

    JSON.parse(text[json_start..json_end]).symbolize_keys
  rescue
    {}
  end
end