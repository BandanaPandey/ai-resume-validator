class Api::SkillGapController < ApplicationController
  def analyze
    resume = params[:resume]
    job_desc = params[:job_description]
    provider_name ||= ENV["EMBEDDINGS_PROVIDER"] || "openai"

    result = SkillGapAnalyzer.new(
      resume_text: resume,
      job_description: job_desc,
      provider: provider_name
    ).call

    puts "SkillGapController: Analysis result: #{result.inspect}"

    render json: result
  end
end