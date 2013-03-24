require 'rumor/spread'

module Rumor

  # Public: A Rumor represents some knowledge about
  # something that can be spread.
  #
  # Examples
  #
  #   Rumor.new(:upgraded).on('user1').mention(plan: :tasty).tag(:business).spread
  #
  class Rumor
    
    # Public: A rumor has an event name.
    # this is required for every rumor.
    attr_accessor :event

    # Public: Wo the rumor is about
    # This is mostly the user that executed the event.
    attr_accessor :object

    # Public: The mentions of the rumor.
    # All the information a rumor mentions.
    attr_accessor :mentions

    # Public: Every rumor has some tags.
    # A Rumor can be categorized in multiple optional tags.
    attr_accessor :tags

    # Public: Create Rumor from hash.
    def self.from_h hash
      self.new(hash[:event]).
        mention(hash[:mentions]).
        on(hash[:object]).
        tag(*hash[:tags]).
        async(hash[:async])
    end

    # Public: Creates a new rumor.
    #
    # subject - subject of the rumor.
    def initialize event
      @event = event
      @tags = []
      @mentions = {}
      @async = false
    end

    # Public: Tell who/what the rumor is concerning.
    def on object
      @object = object
      self
    end

    # Public: Mention some things in the rumor.
    # Merges with already mentioned information.
    def mention mentions
      @mentions.merge!(mentions) do |key, old_val, new_val|
        if old.kind_of?(Array)
          old_val + new_val
        elsif old.kind_of?(Hash)
          old_val.merge new_val
        else
          new_val
        end
      end
      self
    end

    # Public: Add some tags to the rumor.
    def tag *tags
      @tags << tags
      self
    end

    # Public: Copy a rumor while altering information.
    def copy &alter
      Rumor.new(hash).tap &alter
    end

    # Spread the rumor to all applicable channels.
    #
    # conditions - some conditions on the spreading (Hash).
    #             :only - The channels to spread to (and none other).
    #             :except - The channels not to spread to.
    #
    # Returns nothing.
    def spread conditions = {}
      @only = conditions[:only]
      @except = conditions[:except]
      spread!
    end

    # Spread the rumor.
    def spread!
      @time = Time.now
      Rumor.spread rumor
    end

    # Public: The time the rumor was spread.
    def time
      @time
    end

    # Public: Whether to send this rumor to the given channel.
    #
    # channel - Name of the channel.
    def to? channel
      (!@only && !@except) ||
        (@only && @only.include? channel) ||
        (@except && !@except.include? channel)
    end

    # Public: Rumor in hash form.
    #
    # Returns the rumor converted to a Hash.
    def to_h
      {
        event: event,
        object: object,
        mentions: mentions,
        tags: tags,
        async: async?
      }
    end
  end
end
