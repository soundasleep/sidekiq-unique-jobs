# frozen_string_literal: true

module SidekiqUniqueJobs
  class Lock
    # Locks jobs until the server is done executing the job
    # - Locks on perform_in or perform_async
    # - Unlocks after yielding to the worker's perform method
    #
    # @author Mikael Henriksson <mikael@zoolutions.se>
    class UntilExecuted < BaseLock
      OK ||= 'OK'

      # Executes in the Sidekiq server process
      # @yield to the worker class perform method
      def execute
        unless locked?
          log_warn("the unique_key: #{item[UNIQUE_DIGEST_KEY]} is not locked, allowing job to silently complete")
          return
        else
          with_cleanup { yield }
        end
      end
    end
  end
end
