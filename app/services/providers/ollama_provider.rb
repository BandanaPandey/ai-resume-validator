# app/services/ai_providers/ollama_provider.rb
require "net/http"
require "json"

class Providers::OllamaProvider < Providers::BaseProvider
  OLLAMA_URL = ENV["OLLAMA_URL"] || "http://localhost:11434/api/generate"
  MODEL = ENV["OLLAMA_MODEL"] || "llama3"

  def analyze_resume(prompt)
    response = call_ollama(prompt)
    parse(response)
  end

  private

  def call_ollama(prompt)
    uri = URI(OLLAMA_URL)

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, {
      "Content-Type" => "application/json"
    })

    puts "Sending request to Ollama at #{OLLAMA_URL} with model #{MODEL}"
    puts "Prompt: #{prompt}"

    request.body = {
      model: MODEL,
      prompt: prompt,
      stream: false
    }.to_json

    response = http.request(request)
    JSON.parse(response.body)
  end

  def parse(response)
    text = response["response"]
    puts "Received response from Ollama: #{text}"

    begin
      res = parse_json(text)
      puts "Parsed response: #{res}"
      res
    rescue
      {
        score: 65,
        feedback: text || "Unable to parse response"
      }
    end
  end

  def parse_json(text)
    json_start = text.index("{")
    json_end = text.rindex("}")

    return {} unless json_start && json_end

    JSON.parse(text[json_start..json_end]).symbolize_keys
  rescue
    {}
  end
end