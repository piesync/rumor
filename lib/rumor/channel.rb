module Rumor

  # Public: A Channel is a module that can be included in any class.
  #
  # It provides an 'on' method for matching rumors by event.
  class Channel
    class << self
      attr_accessor :handlers
    end

    def self.inherited klass
      klass.handlers = {}
    end

    # Internal: Send a Rumor to this channel.
    def send rumor
      handle = self.class.handlers[rumor.event]
      self.instance_exec rumor, &handle
    end

    # Public: Catch all events with specified name.
    def self.on event, &handle
      self.handlers[event] = handle
    end
  end
end
