# app/services/embeddings/providers/ollama_provider.rb
require "net/http"
require "json"

class Embeddings::Providers::OllamaProvider < Embeddings::Providers::BaseProvider
  OLLAMA_EMBEDDINGS_URL = ENV["OLLAMA_EMBEDDINGS_URL"] || "http://localhost:11434/api/embeddings"
  MODEL = ENV["EMBEDDINGS_MODEL"] || "nomic-embed-text"

  def embed(text)
    uri = URI(OLLAMA_EMBEDDINGS_URL)

    res = Net::HTTP.post(
        uri,
        {
        model: MODEL,
        prompt: text
        }.to_json,
        "Content-Type" => "application/json"
    )

    JSON.parse(res.body)["embedding"]
  end
end