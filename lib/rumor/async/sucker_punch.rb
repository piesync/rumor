require 'time'
require 'sucker_punch'

module Rumor
  module Async

    class SuckerPunch

      def self.send_async channel_name, rumor
        Job.perform_async(channel_name, rumor)
      end

      class Job
        include ::SuckerPunch::Job
        workers ENV["SUCKERPUNCH_WORKERS"] ? ENV["SUCKERPUNCH_WORKERS"].to_i : 2

        def perform channel_name, rumor
          # Send to the channel again.
          ::Rumor.channel(channel_name.to_sym).handle rumor
          nil
        end
      end
    end
  end
end

Rumor.async_handler = Rumor::Async::SuckerPunch
