class Api::JobsController < ApplicationController
  def create
    job = Job.create!(
      title: params[:title],
      description: params[:job_description]
    )

    candidates = params[:candidates].map do |c|
      Candidate.create!(
        name: c[:name],
        resume_text: c[:resume]
      )
    end

    ranked = CandidateRanker.new(
      job_description: job.description,
      candidates: candidates.map { |c| { id: c.id, resume: c.resume_text, name: c.name } },
      provider: :ollama
    ).rank

    persist_results(job, ranked)

    render json: {
      job_id: job.id,
      results: ranked
    }
  end

  private

  def persist_results(job, ranked)
    ranked.each do |r|
      JobApplication.create!(
        job: job,
        candidate_id: r[:candidate_id],
        #candidate_name: r[:candidate_name],
        rank: r[:rank],
        score: r[:score],
        smart_score: r[:details][:smart_score],
        analysis: r[:details]
      )
    end
  end
end