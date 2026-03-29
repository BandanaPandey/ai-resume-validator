class Api::ReportsController < ApplicationController
  def candidate
    candidate = params[:candidate]

    pdf = CandidateReportPdfService.new(candidate).generate

    send_data pdf,
              filename: "candidate_report.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end
end