
module CliTest
  ##
  # Encapsulates the execution results from the command
   class Execution
      extend Forwardable
      attr_reader :stdout, :stderr, :status

      ##
      # creates an object of type CliTest::Execution
      # @param [String] stdout the stdout of the execution
      # @param [String] stderr the stderr of the execution
      # @param [Process::Status] status the status of the execution
      # @return [CliTest::Execution] the execution object
      def initialize(stdout, stderr, status)
          @stdout = stdout
          @stderr = stderr
          @status = status
       end

      ##
      # returns true if the status code for the execution is
      # non zero
      # @return [Boolean] whether the execution was successful
      def successful?
        @status.success?
      end

      def_delegator :@status, :exitstatus
   end
end