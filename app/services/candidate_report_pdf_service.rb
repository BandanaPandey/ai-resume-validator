require "prawn"

class CandidateReportPdfService
  def initialize(candidates:, job_description: nil, title: nil)
    @candidates = normalize_candidates(candidates)
    @job_description = job_description
    @title = title || default_title
  end

  #########################################
  # MAIN
  #########################################
  def generate
    Prawn::Document.new do |pdf|
      header(pdf)
      job_section(pdf) if @job_description.present?

      @candidates.each_with_index do |candidate, index|
        candidate_section(pdf, candidate, index)

        # 🔥 page break only if multiple candidates
        if multiple_candidates? && index < @candidates.size - 1
          pdf.start_new_page
        end
      end
    end.render
  end

  private

  #########################################
  # Normalize input (single OR array)
  #########################################
  def normalize_candidates(candidates)
    return [] if candidates.blank?

    if candidates.is_a?(Array)
      candidates.first(10) # 🔥 enforce top 10
    else
      [candidates] # 🔥 single candidate support
    end
  end

  #########################################
  def multiple_candidates?
    @candidates.size > 1
  end

  #########################################
  def default_title
    multiple_candidates? ? "Top Candidates Report" : "Candidate Report"
  end

  #########################################
  # HEADER
  #########################################
  def header(pdf)
    pdf.text @title, size: 22, style: :bold
    pdf.move_down 10

    pdf.text "Generated at: #{Time.current.strftime('%d %B %Y')}"
    pdf.move_down 15
  end

  #########################################
  # JOB DESCRIPTION
  #########################################
  def job_section(pdf)
    pdf.text "Job Description", style: :bold
    pdf.text truncate(@job_description, 1000)
    pdf.move_down 15
  end

  #########################################
  # CANDIDATE BLOCK
  #########################################
  def candidate_section(pdf, candidate, index)
    pdf.text "#{index + 1}. #{candidate[:candidate_name]}", size: 16, style: :bold

    pdf.text "Score: #{candidate[:score]}"
    pdf.text "Decision: #{candidate[:decision]}"
    pdf.text "Confidence: #{candidate[:confidence]}%"
    pdf.move_down 8

    # Summary
    pdf.text "Summary", style: :bold
    pdf.text candidate[:summary] || "-"
    pdf.move_down 8

    # Highlights
    if present?(candidate[:highlights])
      pdf.text "Strengths", style: :bold
      candidate[:highlights].each { |h| pdf.text "• #{h}" }
      pdf.move_down 8
    end

    # Risks
    if present?(candidate[:risks])
      pdf.text "Risks", style: :bold
      candidate[:risks].each { |r| pdf.text "• #{r}" }
      pdf.move_down 8
    end

    # Decision Reasons
    if present?(candidate[:decision_reasons])
      pdf.text "Why this decision?", style: :bold
      candidate[:decision_reasons].each { |r| pdf.text "• #{r}" }
      pdf.move_down 8
    end

    # Score Breakdown
    if present?(candidate[:score_breakdown])
      pdf.text "Score Breakdown", style: :bold
      candidate[:score_breakdown].each do |k, v|
        pdf.text "#{humanize(k)}: #{v.round}"
      end
    end

    pdf.move_down 15
  end

  #########################################
  # HELPERS
  #########################################
  def truncate(text, length)
    return "" unless text
    text.length > length ? "#{text[0...length]}..." : text
  end

  def present?(val)
    val.respond_to?(:any?) ? val.any? : val.present?
  end

  def humanize(key)
    key.to_s.gsub("_", " ").capitalize
  end
end