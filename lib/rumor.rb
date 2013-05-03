require "rumor/version"
require 'rumor/channel'
require 'rumor/rumor'
require 'rumor/source'

module Rumor
  class << self
    attr_accessor :channels
    attr_accessor :async_handler
  end

  @channels = {}

  # Internal: Register a new channel.
  #
  # name    - Name for the channel.
  # channel - The channel object.
  # options - Some extra options.
  #          :async - Whether to spread asynchronously (default: true).
  #
  # Returns Nothing.
  def self.register name, channel, options = {}
    self.channels[name] = {
      channel: channel,
      options: {
        async: options[:async] || true
      }
    }
    nil
  end

  # Internal: Get a channel.
  def self.channel name
    self.channels[name][:channel]
  end

  # Internal: Spread a rumor to required channels.
  def self.spread rumor, options = {}
    self.channels.each do |name, channel|
      # Skip if we don't need to send to this channel.
      next unless rumor.to?(name)
      # Get the channel and the options.
      options = channel[:options].merge! options
      channel = channel[:channel]
      # Send via async handler if async.
      # Directly to the channel if not.
      if options[:async]
        self.async_handler.send_async name, rumor
      else
        channel.send rumor, options
      end
    end
  end
end
