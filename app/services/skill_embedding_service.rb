class SkillEmbeddingService
  def initialize(provider:)
    @provider = Embeddings::Providers::ProviderFactory.build(provider)
  end

  def find_or_create(skill_name)
    puts "SkillEmbeddingService: Finding or creating embedding for skill: #{skill_name} using provider #{@provider.class.name}"
    # binding.pry
    skill = Skill.find_by(name: skill_name.downcase)
    return skill if skill

    embedding = @provider.embed(skill_name)

    Skill.create!(
      name: skill_name.downcase,
      embedding: "[#{embedding.join(',')}]"
    )
  end
end