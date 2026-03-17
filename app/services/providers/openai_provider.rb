# app/services/ai_providers/openai_provider.rb
class Providers::OpenAIProvider < Providers::BaseProvider
  def initialize
    @client = OpenAI::Client.new
  end

  def analyze_resume(prompt)
    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "user", content: prompt }
        ]
      }
    )

    parse(response)
  end

  private

  def parse(response)
    text = response.dig("choices", 0, "message", "content")

    begin
      parse_json(text)
    rescue
      { score: 70, feedback: text }
    end
  end

  def parse_json(text)
    json_start = text.index("{")
    json_end = text.rindex("}")

    return {} unless json_start && json_end

    JSON.parse(text[json_start..json_end]).symbolize_keys
  rescue
    {}
  end
end