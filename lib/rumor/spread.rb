module Rumor

  # Public: This model has final control over how a rumor will be spread.
  class Spread

    # Public: Create new instructions to spread a rumor.
    #
    # rumor      - The rumor to spread.
    # conditions - some conditions on the spreading (Hash).
    #             :only - The channels to spread to (and none other).
    #             :except - The channels not to spread to.
    #
    def initialize rumor, conditions = {}
      @rumor = rumor
      @only = conditions[:only]
      @except = conditions[:except]
    end

    # Public: Whether to send to the given channel.
    #
    # channel - Name of the channel.
    def to? channel
      (!@only && !@except) ||
        (@only && @only.include? channel) ||
        (@except && !@except.include? channel)
    end
  end
end
