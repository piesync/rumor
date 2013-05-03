require 'time'
require 'resque'

module Rumor
  module Async

    class Resque

      def self.send_async channel_name, rumor
        ::Resque.enqueue Job, channel_name, rumor.to_h
      end

      class Job
        @queue = :rumor

        def self.perform channel_name, rumor_hash
          hash = hash_to_symbols rumor_hash
          hash[:mentions] = hash_to_symbols hash[:mentions]
          hash[:tags].map! &:to_sym
          hash[:time] = Time.parse hash[:time]
          # Deserialize the rumor.
          rumor = Rumor.from_h hash
          # Send to the channel again.
          ::Rumor.channel(channel_name.to_sym).handle rumor
          nil
        end

        def self.hash_to_symbols hash
          symbol_hash = {}
          hash.each do |k,v|
            symbol_hash[k.to_sym] = v
          end
          symbol_hash
        end
      end
    end
  end
end

Rumor.async_handler = Rumor::Async::Resque
