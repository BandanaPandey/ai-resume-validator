# app/services/ai_providers/base_provider.rb
class Providers::BaseProvider
  def analyze_resume(prompt)
    raise NotImplementedError, "Must implement analyze_resume"
  end
end