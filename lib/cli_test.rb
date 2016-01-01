require 'open3'

require 'cli-test/version'
require 'cli-test/execution'

module CliTest

  ## 
  # Error class that will be used for all errors raise by library
  class Error < StandardError
  end

  ##
  # executes the supplied script and returns the results
  # @param [String] command the command to be executed
  # @return [CliTest::Execution] an Execution object containing the results
  def execute(command)
    @executions ||= []
    o,e,s = Open3.capture3(command)
    exe = Execution.new(o,e,s)
    @executions << exe
    exe
  end

  ##
  # executes the supplied Ruby script. Because Windows can't use shebangs to
  # to figure out the correct intepreter 'ruby' is explicitly added to the command.
  # If `use_bundler` is true then the script is executed with `bundle exec`.
  # @param [String] script_path the relative or absolute path of a script to execute
  # @param [Boolean] use_bundler if set executes the script within the bundler
  #   context
  # @return [CliTest::Execution] the execution object from running the script
  def execute_script(script_path, use_bundler=false)
    cmd = script_path
    cmd = "ruby #{cmd}" if RUBY_PLATFORM =~ /mswin|mingw|cygwin/
    cmd = "bundle exec #{cmd}" if use_bundler

    execute(cmd)
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
end