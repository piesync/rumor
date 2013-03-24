require "rumor/version"
require 'rumor/channel'
require 'rumor/rumor'
require 'rumor/async'

module Rumor
  class << self
    attr_accessor :channels
    attr_accessor :async_handler
  end

  @channels = {}
  @async_handler = Async::Resque

  # Internal: Register a new channel.
  def self.register name, channel
    self.channels[name] = channel
  end

  # Internal: Spread a rumor to required channels.
  def self.spread rumor
    self.channels.each do |name, channel|
      channel.send rumor if rumor.to?(name)
    end
  end

  # Internal: Spread a rumor asynchronously.
  def self.spread_async rumor
    self.async_handler.spread_async rumor
  end
end
