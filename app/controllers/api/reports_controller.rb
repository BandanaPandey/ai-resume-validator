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

  #########################################
  # 📩 Email Shortlist
  #########################################
  def email_shortlist
    email = params[:email]
    candidates = params[:candidates] || []
    job_description = params[:job_description]

    if email.blank?
      return render json: { error: "Email is required" }, status: :unprocessable_entity
    end

    ReportMailer
      .shortlist_email(email, candidates, job_description)
      .deliver_now # 🔥 for simplicity, using deliver_now. In production, consider deliver_later with ActiveJob and a background worker like Sidekiq for better performance and user experience.
      #.deliver_later # 🔥 async

    render json: { message: "Email sent successfully" }
  end
end