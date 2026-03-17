# app/services/ai_providers/provider_factory.rb
module Providers
  class ProviderFactory
    def self.build(provider_name = nil)
      provider_name ||= ENV["AI_PROVIDER"] || "openai"

      case provider_name
      when "openai"
        Providers::OpenAIProvider.new
      when "anthropic"
        Providers::AnthropicProvider.new
      when "ollama"
        Providers::OllamaProvider.new
      else
        raise "Unsupported AI provider: #{provider_name}"
      end
    end
  end
end