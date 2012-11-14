module Rumor

  # Public: This model has final control over how a rumor will be spread.
  class Spread

    def to channel
      rumor = block_given? ? yield(@rumor) : @rumor
      channel.push rumor if elegible?(channel)
    end
  end
end
