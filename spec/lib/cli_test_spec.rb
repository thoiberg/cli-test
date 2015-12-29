require 'cli_test'

describe CliTest do
    let(:dummy_class) { Class.new { include CliTest }.new }
    let(:simple_script) { File.expand_path('../../fixtures/simple_script.rb', __FILE__) }

    describe '#execute' do
        it 'executes the given script and returns the execution details' do
            execution = dummy_class.execute('pwd')

            expect(execution).to be_a_kind_of(CliTest::Execution)
            expect(execution.exitstatus).to eq(0)
        end
    end
end