# app/services/llm/providers/base_provider.rb
class Llm::Providers::BaseProvider
  def analyze_resume(prompt)
    raise NotImplementedError, "Must implement analyze_resume"
  end
  
  def compare_candidates(prompt)
    raise NotImplementedError, "Must implement compare_candidates"
  end
end