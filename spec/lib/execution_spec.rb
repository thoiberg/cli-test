require 'cli-test/execution'

describe CliTest::Execution do
  let(:status) { instance_double(Process::Status) }
  let(:execution) { CliTest::Execution.new('stdout', 'stderr', status) }


  describe '#initialize' do
    it 'creates an instance with the stdout, stderr and status of an execution' do
      execution = CliTest::Execution.new('stdout', 'stderr', status)
            
      expect(execution).to be_a_kind_of(CliTest::Execution)
      expect(execution.stdout).to eq('stdout')
      expect(execution.stderr).to eq('stderr')
      expect(execution.status).to eq(status)
    end
  end

  describe '#successful?' do
    it 'returns true if the status code is 0' do
      allow(status).to receive(:success?) { true }

      expect(execution.successful?).to be_truthy
    end

    it 'returns false if the status code is non-zero' do
      allow(status).to receive(:success?) { false }

      expect(execution.successful?).to be_falsey
    end

  end
end