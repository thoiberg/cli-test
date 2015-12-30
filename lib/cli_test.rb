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
  # convenience method to return last execution object for testing
  # @return [CliTest::Execution] the last execution object
  def last_execution
    unless @executions
      raise Error.new('No executions have occured')
    end

    @executions.last
  end
end