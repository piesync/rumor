require "rumor/version"
require 'rumor/channel'
require 'rumor/rumor'

module Rumor
  class << self
    attr_accessor :channels
  end

  @channels = {}

  # Public: Register a new channel.
  def self.register name, channel
    self.channels[name] = channel
  end

  # Public: Spread a rumor to required channels.
  def self.spread rumor
    self.channels.each do |name, channel|
      channel.send rumor if rumor.to?(name)
    end
  end
end
