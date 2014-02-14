# encoding: utf-8
require 'json'
require 'json-schema'
require 'json_spec'
require 'fileutils'

RSpec.configure do |c|
  c.filter_run_excluding :schema_version => ENV['EXCLUDE_SCHEMA_VERSION']
  c.include JsonSpec::Helpers
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

def save_environment_variable key, value
  "export #{key}=#{value}"
end

def setup_env_vars vars
  FileUtils.mkdir_p 'tmp'
  file = File.open("tmp/challenge_opts", 'w')
  vars.each do |key, value|
    file.puts save_environment_variable(key, value)
  end
  file.close
  file.path
end

def invoke_challenge challenge, example_file
  example_file = File.absolute_path example_file
  Bundler.with_clean_env do
    Dir.chdir '..' do
      example_file = example_file.gsub(Dir.pwd + '/', '')
      setup_env_vars({
        'CHALLENGE' => challenge,
        'SAMPLE_FILE' => example_file
      })
      # pending "#{challenge_script} does not exist" unless File.readable? challenge_script
      system "travis run after_script"
      File.read "tmp/test_output"
    end
  end
end

def validate schema, example_file, version
  JSON::Validator.validate!(schema, File.read(example_file), :version => version, :validate_schema => true)
end
