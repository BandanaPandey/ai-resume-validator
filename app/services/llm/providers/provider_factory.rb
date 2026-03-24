# app/services/llm/providers/provider_factory.rb
module Llm::Providers
  class ProviderFactory
    def self.build(provider_name = nil)
      provider_name ||= ENV["AI_PROVIDER"] || "openai"
      provider_name = provider_name.to_s.downcase

      case provider_name
      when "openai"
        Llm::Providers::OpenAIProvider.new
      when "anthropic"
        Llm::Providers::AnthropicProvider.new
      when "ollama"
        Llm::Providers::OllamaProvider.new
      else
        raise "Unsupported AI provider: #{provider_name}"
      end
    end
  end
end