require 'open3'

require 'cli-test/version'
require 'cli-test/execution'

module CliTest

  ## 
  # Error class that will be used for all errors raise by library
  class Error < StandardError
  end

  ##
  # executes the supplied script and returns the results. If stdin_data
  # is supplied it is passed to the command.
  # @param [String] command the command to be executed
  # @param [Hash] options a hash of options for the execution. valid values are:
  #
  #    - `stdin_data`: data to be passed into the STDIN of the command. If an array 
  #   is passed in then the data is concatenated using <tt>\n</tt>  to simulate
  #   multiple STDIN entries, as most scripts consider <tt>\n</tt> to be the end 
  #   character for input.
  # @return [CliTest::Execution] an Execution object containing the results
  def execute(command, options={})
    # if stdin_data is array then convert into a newline delineated string otherwise return as is
    stdin_data = options[:stdin_data].respond_to?(:join) ? options[:stdin_data].join("\n") : options[:stdin_data]
    @executions ||= []
    o,e,s = Open3.capture3(command, stdin_data: stdin_data)
    exe = Execution.new(o,e,s)
    @executions << exe
    exe
  end

  ##
  # executes the supplied Ruby script. Because Windows can't use shebangs to
  # to figure out the correct intepreter 'ruby' is explicitly added to the command.
  # If `use_bundler` is true then the script is executed with `bundle exec`.
  # @param [String] script_path the relative or absolute path of a script to execute
  # @param [Hash] options a hash of options to be used during the execution
  #   valid options are:
  #
  #   - `use_bundler`: if set executes the script within the context of bundler
  #   - `stdin_data`: data to be passed in to the STDIN of the execution
  #   - `args`: any command line arguments to be supplied to the script. If an array is 
  #   supplied then each entry is treated as a separate argument. Any arguments supplied
  #   are converted to strings using the `to_s` method before the script is executed
  # @return [CliTest::Execution] the execution object from running the script
  def execute_script(script_path, options={})
    # if args is an array convert into space delineated string otherwise return as is
    args = options[:args].respond_to?(:join) ? options[:args].join(" ") : options[:args]
    
    cmd = script_path
    cmd = "ruby #{cmd}" if RUBY_PLATFORM =~ /mswin|mingw|cygwin/
    cmd = "bundle exec #{cmd}" if options[:use_bundler]
    cmd = "#{cmd} #{args}" if args

    execute(cmd, options)
  end

  ##
  # convenience method to return last execution object for testing
  # @return [CliTest::Execution] the last execution object
  def last_execution
    unless @executions
      raise Error.new('No executions have occured')
    end

    @executions.last
  end

  alias_method :run, :execute
  alias_method :run_script, :execute_script
  alias_method :last_run, :last_execution
end