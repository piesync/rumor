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
    attr_accessor :subject

    # Public: The mentions of the rumor.
    # All the information a rumor mentions.
    attr_accessor :mentions

    # Public: Every rumor has some tags.
    # A Rumor can be categorized in multiple optional tags.
    attr_accessor :tags

    # Public: Create Rumor from hash.
    def self.from_h hash
      self.new(hash[:event], hash[:time]).
        mention(hash[:mentions]).
        on(hash[:subject]).
        tag(*hash[:tags])
    end

    # Public: Creates a new rumor.
    #
    # event - event of the rumor.
    def initialize event, time = nil
      @event = event
      @tags = []
      @mentions = {}
      @time = time
    end

    # Public: Tell who/what the rumor is concerning.
    def on subject
      @subject = subject
      self
    end

    # Public: Mention some things in the rumor.
    # Merges with already mentioned information.
    def mention mentions = {}
      @mentions.merge!(mentions) do |key, old_val, new_val|
        if old_val.kind_of?(Array)
          old_val + new_val
        elsif old_val.kind_of?(Hash)
          old_val.merge new_val
        else
          new_val
        end
      end
      self
    end

    # Public: Add some tags to the rumor.
    def tag *tags
      @tags += tags
      self
    end

    # Public: Copy a rumor while altering information.
    def copy &alter
      Rumor.new(hash).tap &alter
    end

    # Spread the rumor to all applicable channels.
    #
    # conditions - some conditions on the spreading (Hash).
    #             :only   - The channels to spread to (and none other).
    #             :except - The channels not to spread to.
    #             :async  - Whether to spread asynchronously (default: true).
    #
    # Returns nothing.
    def spread conditions = {}
      @time = Time.now.utc
      @only = conditions.delete :only
      @except = conditions.delete :except
      ::Rumor.spread self, conditions
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
        (@only && @only.include?(channel)) ||
        (@except && !@except.include?(channel))
    end

    # Public: Rumor in hash form.
    #
    # Returns the rumor converted to a Hash.
    def to_h
      {
        event: event,
        subject: subject,
        mentions: mentions,
        tags: tags,
        time: time
      }
    end
  end
end
