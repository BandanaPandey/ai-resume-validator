# app/services/llm/providers/openai_provider.rb
class Llm::Providers::OpenAIProvider < Llm::Providers::BaseProvider
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
      Llm::Providers::JsonParser.safe_parse(text)
    rescue
      { score: 70, feedback: text }
    end
  end
end