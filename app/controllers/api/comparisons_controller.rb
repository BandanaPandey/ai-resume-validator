# app/controllers/api/comparisons_controller.rb
class Api::ComparisonsController < ApplicationController
  def compare_candidates
    candidates = params[:candidates]

    result = CandidateComparisonService.new(
      candidates: candidates,
      job_description: params[:job_description],
      provider: params[:provider] || :ollama
    ).call

    render json: { summary: result }
  end
end