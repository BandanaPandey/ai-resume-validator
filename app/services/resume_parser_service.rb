require 'pdf/reader'

class ResumeParserService
  def initialize(file)
    @file = file
  end

  def extract_text
    return "" unless @file

    reader = PDF::Reader.new(@file.path)

    text = reader.pages.map(&:text).join("\n")

    clean(text)
  rescue => e
    Rails.logger.error("PDF parsing failed: #{e.message}")
    ""
  end

  private

  def clean(text)
    text
      .gsub(/\s+/, " ")
      .strip
  end
end