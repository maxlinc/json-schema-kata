# encoding: utf-8
require 'json'
require 'json-schema'

RSpec.configure do |c|
  c.filter_run_excluding :schema_version => ENV['EXCLUDE_SCHEMA_VERSION']
end

def clean_output(output)
  begin
    json = JSON.parse output
    output = JSON.pretty_generate json
  rescue JSON::ParserError => e
    $stderr.puts "Warning: JSON was not parsable: #{e.message}"
  end
  output
end

def compare_without_whitespace actual, expected
  actual_cleaned = clean_output actual
  expected_cleaned = clean_output expected
  expect(actual_cleaned).to eq expected_cleaned
end

def invoke_challenge challenge, example_file
  example_file = File.absolute_path example_file
  example_file = example_file.gsub(Dir.pwd + '/', '')
  challenge_script = "../scripts/challenges/#{challenge}"
  pending "#{challenge_script} does not exist" unless File.readable? challenge_script
  `#{challenge_script} #{example_file}`
end

def validate schema, example_file, version
  JSON::Validator.validate!(schema, File.read(example_file), :version => version, :validate_schema => true)
end
