require 'open3'

require 'cli-test/version'
require 'cli-test/execution'

module CliTest

    ##
    # executes the supplied script and returns the results
    # @param [String] command the command to be executed
    # @return [CliTest::Execution] an Execution object containing the results
    def execute(command)
        o,e,s = Open3.capture3(command)
        Execution.new(o,e,s)
    end
end