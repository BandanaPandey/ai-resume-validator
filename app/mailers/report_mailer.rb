class ReportMailer < ApplicationMailer
  default from: "no-reply@yourats.com"

  #########################################
  # 📄 Send Top Candidates Report
  #########################################
  def shortlist_email(email, candidates, job_description, provider = nil)
    @job_description = job_description

    #########################################
    # 🔥 Generate AI Summary
    #########################################
    @ai_summary = CandidateComparisonService.new(
        candidates: candidates,
        job_description: job_description,
        provider: provider
    ).call

    pdf = CandidateReportPdfService
            .new(candidates: candidates, job_description: job_description, title: "Top Candidates Report")
            .generate

    attachments["top_candidates_report.pdf"] = pdf

    mail(
      to: email,
      subject: "Top Candidates Report"
    )
  end
end