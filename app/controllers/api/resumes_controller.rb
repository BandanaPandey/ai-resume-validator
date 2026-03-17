class Api::ResumesController < ApplicationController
  def create
    resume = Resume.create(resume_params)

    analysis = ResumeAnalyzerService.new(resume.content).analyze

    resume.update(
      score: analysis[:score],
      feedback: analysis[:feedback]
    )

    render json: resume
  end

  private

  def resume_params
    params.permit(:filename, :content)
  end
end