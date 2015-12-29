require 'cli_test'

describe CliTest do
    let(:dummy_class) { Class.new { include CliTest }.new }
    let(:simple_script) { File.expand_path('../../fixtures/simple_script.rb', __FILE__) }

    describe '#execute' do
        it 'executes the given command and returns the execution details' do
            execution = dummy_class.execute('ruby --version')

            expect(execution).to be_a_kind_of(CliTest::Execution)
            expect(execution.exitstatus).to eq(0)
        end
    end

    describe '#last_execution' do
        it 'returns the last execution object' do
            execution = dummy_class.execute('ruby --version')
            expect(dummy_class.last_execution).to eq(execution)
        end

        it 'raises an error if there has been no execution' do
            expect(dummy_class.instance_variable_get(:@executions)).to be_nil

            expect { dummy_class.last_execution }.to raise_error(CliTest::Error)
        end
    end
end