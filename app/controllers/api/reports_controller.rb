class Api::ReportsController < ApplicationController
  def candidate
    candidate = params[:candidate]

    pdf = CandidateReportPdfService.new(
        candidates: candidate,
        job_description: params[:job_description],
        title: "Candidate Report"
    ).generate

    send_data pdf,
                filename: "candidate_report.pdf",
                type: "application/pdf",
                disposition: "attachment"
    end

  def shortlist
    candidates = params[:candidates]

    pdf = CandidateReportPdfService.new(
        candidates: candidates,
        job_description: params[:job_description],
        title: "Top Candidates Report"
    ).generate

    send_data pdf,
                filename: "top_candidates_report.pdf",
                type: "application/pdf",
                disposition: "attachment"
    end
end