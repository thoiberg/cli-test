require 'cli-test/execution'

describe CliTest::Execution do
    let(:status) { double(Process::Status) }


    describe '#initialize' do
        it 'creates an instance with the stdout, stderr and status of an execution' do
            execution = CliTest::Execution.new('stdout', 'stderr', status)
            
            expect(execution).to be_a_kind_of(CliTest::Execution)
            expect(execution.stdout).to eq('stdout')
            expect(execution.stderr).to eq('stderr')
            expect(execution.status).to eq(status)
        end
    end
end