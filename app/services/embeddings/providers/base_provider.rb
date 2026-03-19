# app/services/llm/providers/base_provider.rb
class Embeddings::Providers::BaseProvider
  def embed(text)
      raise NotImplementedError
    end
end