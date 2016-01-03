# cli-test
Ruby gem for easy testing of command line scripts

# Installation
To install cli-test use the following command:

    $ gem install cli-test

# Examples
To use cli-test include `CliTest` in your test code and execute the desired command or script

    require 'cli-test'

    describe 'MyScript' do
        include CliTest

        it 'executes successfully' do
            execute_script('hello_world.rb')

            expect(last_execution).to be_successful
            expect(last_execution.stdout).to eq("Hello World\n")
            expect(last_execution.stderr).to be_empty
        end
    end

The script can be executed with bundler with the `use_bundler` option

    it 'uses bundler to execute' do
        execute_script('hello_world.rb', use_bundler: true)

        expect(last_execution).to be_successful
    end

Arguments can be supplied with the `args` option. If an Array is passed in then each entry
will be treated as a separate argument. Any arguments are converted to strings using `to_s` before
being executed.

    it 'can accept arguments' do
        execute_script('args.rb', args: [1,2,3])

        expect(last_execution.stdout).to eq("1,2,3\n")
    end

Data can be passed into the STDIN of the command with the `stdin_data` option

    it 'can pass in data to the STDIN' do
        execute_script('hello.rb', stdin_data: 'world')

        expect(last_execution.stdout).to eq("Hello world\n")
    end

If an array is passed in then each entry is treated as a separate STDIN entry

    it 'can pass in data to the STDIN' do
        execute_script('hello.rb', stdin_data: ['world', 'globe'])

        expect(last_execution.stdout).to eq("Hello world\nHello globe\n")
    end

Direct commands can be executed using the `execute` command

    it 'can execute commands' do
        execute('ruby --version')

        expect(last_execution).to be_successful
    end

# License
cli-test is licensed under the [MIT License](License)

