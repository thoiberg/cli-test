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

  describe '#execute_script' do
    it 'runs the supplied script' do
      execution = dummy_class.execute_script(simple_script)

      expect(execution).to be_successful
      expect(execution.stdout).to eq("Hey\n")
    end

    it 'executes the script within bundler context if option is set' do
      expect(Open3).to receive(:capture3).with("bundle exec #{simple_script}").and_call_original
      execution = dummy_class.execute_script(simple_script, true)

      expect(execution).to be_successful
    end

    context 'on Windows' do
      before(:each) do
        stub_const('RUBY_PLATFORM', 'i386-mingw32')
      end
      it 'specifically uses the Ruby intepreter' do       
        expect(Open3).to receive(:capture3).with("ruby #{simple_script}").and_call_original
        execution = dummy_class.execute_script(simple_script)

        expect(execution).to be_successful
      end

      it 'can use bundle and the ruby intepreter if use_bundler is set' do
        expect(Open3).to receive(:capture3).with("bundle exec ruby #{simple_script}").and_call_original
        execution = dummy_class.execute_script(simple_script, true)

        expect(execution).to be_successful
      end
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