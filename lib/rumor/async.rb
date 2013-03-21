module Rumor
  module Async

    class Resque

      def spread rumor
        Resque.enqueue Job, rumor.to_h
      end

      class Job

        def self.perform rumor_hash
          # The rumor is not async anymore.
          rumor = Rumor.from_hash(rumor_hash).async(false)
          # Spread again.
          rumor.spread!
        end
      end
    end
  end
end
