# encoding: utf-8
def run_test example_file, challenge, schema_version = :draft4
  example = File.basename example_file
  expected = File.expand_path(example, "spec/fixtures/schemas/#{challenge.to_s}")
  it "for #{example}" do
    schema = invoke_challenge "generate_#{challenge}", example_file
    expect(schema).to be_json_eql(File.read(expected))
    validate schema, example_file, schema_version
  end
end

describe 'generator' do
  drafts = [:draft3, :draft4].each do |draft|
    context "supports #{draft}", :schema_version => draft do
      context 'the description' do
        let(:schema) { invoke_challenge "generate_#{draft}", 'spec/fixtures/examples/simple.json' }
        it 'includes the file name' do
          expect(schema).to include('Generated from kata/spec/fixtures/examples/simple.json')
        end
        it 'includes the file shasum' do
          expect(schema).to include('with shasum e7f0e9796c7719ec437027ff34c84b353dabd49e')
        end
      end

      context 'generates the examples' do
        Dir['spec/fixtures/examples/*.json'].each do |example_file|
          run_test example_file, draft, draft
        end
      end
    end
  end

  options = [:defaults].each do |option|
    context "supports #{option} option" do
      Dir['spec/fixtures/examples/*.json'].each do |example_file|
        run_test example_file, option
      end
    end
  end
end
