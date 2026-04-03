class Api::JobsController < ApplicationController
  def create
    job = current_user.jobs.create!(
      title: params[:title],
      description: params[:job_description]
    )

    processed_candidates = params[:candidates].values.map do |c|
      file = c[:file]
      puts "FILE CLASS: #{file.class}"
      resume_text = if file && file.is_a?(ActionDispatch::Http::UploadedFile)
        ResumeParserService.new(file).extract_text
      else
        c[:resume]
      end
      {
        name: c[:name],
        resume: resume_text
      }
    end

    candidates = processed_candidates.map do |c|
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