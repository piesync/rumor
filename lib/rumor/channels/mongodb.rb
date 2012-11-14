require 'moped'

module Rumor
  module Channels

    class MongoDb

      def initialize url
      end

      def put rumor
        @collection.insert { _id: Moped::BSON::ObjectId.new }.merge!(rumor.hash)
      end

      def search rumor
      end
    end
  end
end
