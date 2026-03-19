# app/services/embeddings/providers/openai_provider.rb
class Embeddings::Providers::OpenAIProvider < Embeddings::Providers::BaseProvider
  def initialize
    @client = OpenAI::Client.new
  end

  def embed(text)
    response = @client.embeddings(
        parameters: {
          model: "text-embedding-3-small",
          input: text
        }
      )

      response.dig("data", 0, "embedding")
  end
end