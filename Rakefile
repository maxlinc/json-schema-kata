# encoding: utf-8

require 'rspec/core/rake_task'
require 'json'
require 'json-schema'
require 'jsonpath'

RSpec::Core::RakeTask.new('spec')
task :default => :spec

desc 'Ensure the reference schemas can validate the examples'
task :validate_schemas do
  failures = []
  Dir['spec/fixtures/examples/*.json'].each do |example_file|
    example = File.basename example_file
    data = JSON.load(File.read example_file)

    [:draft3, :draft4].each do |version|
      schema = "spec/fixtures/schemas/#{version.to_s}/#{example}"
      puts "Running tests for #{schema}"
      begin
        # Validate full message
        JSON::Validator.validate! schema, data, :version => version, :validate_schema => true
      rescue => e
        failures << example
        $stderr.puts "#{example}: #{e.message}"
      end
      # Everything is required, dropping any field should cause a validation error
      data = JSON.load(File.read example_file)
      test_subsets_fail data, schema, version
    end
  end
  if failures.empty?
    puts "All valid"
  else
    fail "Errors in #{failures.join ', '}" unless failures.empty?
  end
end

def test_subsets_fail data, schema, version, json_path = '$'
  subset = JsonPath.on(data, json_path).first
  subset.each do |key, value|
    json_subpath = "#{json_path}.#{key}"
    if value.respond_to? :keys
      value.keys.each do |k|
        test_subsets_fail data, schema, version, json_subpath
      end
    else
      puts "Testing #{schema} without #{json_subpath}"
      filtered_subset = JsonPath.for(data).delete(json_subpath).to_hash
      passed = JSON::Validator.validate schema, filtered_subset, :version => version, :validate_schema => true
      fail "Should have failed when #{json_subpath} was missing" if passed
    end
  end
end
