require 'prawn'

class CandidateReportPdfService
  def initialize(candidate)
    @candidate = candidate
  end

  def generate
    Prawn::Document.new do |pdf|
      header(pdf)
      score_section(pdf)
      summary(pdf)
      highlights(pdf)
      risks(pdf)
      breakdown(pdf)
    end.render
  end

  private

  #########################################
  def header(pdf)
    pdf.text "Candidate Report", size: 22, style: :bold
    pdf.move_down 10

    pdf.text "Name: #{@candidate[:candidate_name]}"
    pdf.text "Rank: #{@candidate[:rank]}"
    pdf.move_down 10
  end

  #########################################
  def score_section(pdf)
    pdf.text "Score: #{@candidate[:score]}", size: 16, style: :bold
    pdf.text "Decision: #{@candidate[:decision]}"
    pdf.text "Confidence: #{@candidate[:confidence]}%"
    pdf.move_down 10
  end

  #########################################
  def summary(pdf)
    pdf.text "Summary", style: :bold
    pdf.text @candidate[:summary] || "-"
    pdf.move_down 10
  end

  #########################################
  def highlights(pdf)
    return if @candidate[:highlights].blank?

    pdf.text "Strengths", style: :bold
    @candidate[:highlights].each do |h|
      pdf.text "• #{h}"
    end
    pdf.move_down 10
  end

  #########################################
  def risks(pdf)
    return if @candidate[:risks].blank?

    pdf.text "Risks", style: :bold
    @candidate[:risks].each do |r|
      pdf.text "• #{r}"
    end
    pdf.move_down 10
  end

  #########################################
  def breakdown(pdf)
    return unless @candidate[:score_breakdown]

    pdf.text "Score Breakdown", style: :bold

    @candidate[:score_breakdown].each do |k, v|
      pdf.text "#{k.to_s.humanize}: #{v.round}"
    end
  end
end