class Api::SkillGapController < ApplicationController
  def analyze
    resume = params[:resume]
    job_desc = params[:job_description]

    result = SkillGapAnalyzer.new(
      resume_text: resume,
      job_description: job_desc
    ).call

    render json: result
  end
end