# app/services/llm/providers/anthropic_provider.rb
class Llm::Providers::AnthropicProvider < Llm::Providers::BaseProvider
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
      Llm::Providers::JsonParser.safe_parse(text)
    rescue
      { score: 70, feedback: text }
    end
  end
end