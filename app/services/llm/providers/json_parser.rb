# app/services/llm/providers/json_parser.rb
module Llm::Providers::JsonParser
  def self.safe_parse(text)
    json_start = text.index("{")
    json_end = text.rindex("}")

    return {} unless json_start && json_end

    JSON.parse(text[json_start..json_end]).symbolize_keys
  rescue
    {}
  end
end