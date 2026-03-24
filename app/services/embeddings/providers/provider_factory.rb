# app/services/llm/providers/provider_factory.rb
module Embeddings::Providers
  class ProviderFactory
    def self.build(provider_name = nil)
      provider_name ||= ENV["EMBEDDINGS_PROVIDER"] || "openai"

      provider_name = provider_name.to_s.downcase

      case provider_name
      when "openai"
        Embeddings::Providers::OpenAIProvider.new
      when "ollama"
        Embeddings::Providers::OllamaProvider.new
      else
        raise "Unsupported AI provider: #{provider_name}"
      end
    end
  end
end