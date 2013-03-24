module Rumor
  module Async

    class Resque

      def self.spread_async rumor
        ::Resque.enqueue Job, rumor.to_h
      end

      class Job

        def self.perform rumor_hash
          # Deserialize the rumor.
          rumor = Rumor.from_hash(rumor_hash)
          # Spread again.
          rumor.spread!
        end
      end
    end
  end
end
