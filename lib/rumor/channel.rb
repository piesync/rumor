module Rumor

  # Public: A Channel is a module that can be included in any class.
  #
  # It provides an 'on' method for matching rumors by event.
  class Channel

    # Public: Catch all events with specified name.
    def self.on event
    end
  end
end
