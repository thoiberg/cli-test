require 'cli_test'

describe CliTest do
  let(:dummy_class) { Class.new { include CliTest }.new }
  let(:fixtures_directory) { File.expand_path('../../fixtures/', __FILE__) }
  let(:simple_script) { "#{fixtures_directory}/simple_script.rb" }
  let(:stdin_script) { "#{fixtures_directory}/stdin_script.rb" }
  let(:stdin_w_multiple_script) { "#{fixtures_directory}/multiple_inputs_script.rb" }

  describe '#execute' do
      it 'executes the given command and returns the execution details' do
          execution = dummy_class.execute('ruby --version')

          expect(execution).to be_a_kind_of(CliTest::Execution)
          expect(execution.exitstatus).to eq(0)
      end

      it 'can accept data for stdin' do
        execution = dummy_class.execute(%Q{ruby -e "test = gets.chomp;puts test"}, 
                                        stdin_data: 'flargetnuten')

        expect(execution).to be_successful
        expect(execution.stdout).to eq("flargetnuten\n")
      end

      it 'treats an array of stdin_data as multiple inputs' do
        execution = dummy_class.execute(%Q{ruby -e "test1 = gets.chomp;test2 = gets.chomp;puts test1;puts test2"}, 
                                        stdin_data: ['a', 'b'])

        expect(execution).to be_successful
        expect(execution.stdout).to eq("a\nb\n")
      end
  end

  describe '#execute_script' do
    it 'runs the supplied script' do
      execution = dummy_class.execute_script(simple_script)

      expect(execution).to be_successful
      expect(execution.stdout).to eq("Hey\n")
    end

    it 'executes the script within bundler context if option is set' do
      expect(Open3).to receive(:capture3).with("bundle exec #{simple_script}", anything).and_call_original
      execution = dummy_class.execute_script(simple_script, use_bundler: true)

      expect(execution).to be_successful
    end

    it 'can pass in data to the STDIN of the execution' do
      execution = dummy_class.execute_script(stdin_script, stdin_data: 'apple')

      expect(execution).to be_successful
      expect(execution.stdout).to eq("favourite fruit:\napple\n")
    end

    it 'treats an array of entries for stdin_data as separate entries' do
      execution = dummy_class.execute_script(stdin_w_multiple_script, stdin_data: ['apple', 'banana', 'orange'])

      expect(execution).to be_successful
      expect(execution.stdout).to eq("3 favourite fruit:\napple,banana,orange\n")
    end

    context 'on Windows' do
      before(:each) do
        stub_const('RUBY_PLATFORM', 'i386-mingw32')
      end
      it 'specifically uses the Ruby intepreter' do       
        expect(Open3).to receive(:capture3).with("ruby #{simple_script}", anything).and_call_original
        execution = dummy_class.execute_script(simple_script)

        expect(execution).to be_successful
      end

      it 'can use bundle and the ruby intepreter if use_bundler is set' do
        expect(Open3).to receive(:capture3).with("bundle exec ruby #{simple_script}", anything).and_call_original
        execution = dummy_class.execute_script(simple_script, use_bundler: true)

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