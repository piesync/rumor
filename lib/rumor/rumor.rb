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
    include Mongoid::Document
    store_in 'rumor.rumors'

    # Public: A rumor has a subject, the event name.
    # this is required for every rumor.
    attr_accessor :subject

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
      self.new(hash[:subject]).
        mention(hash[:mentions]).
        on(hash[:object]).
        tag(*hash[:tags]).
        async(hash[:async])
    end

    # Public: Creates a new rumor.
    #
    # subject - subject of the rumor.
    def initialize subject = nil
      @subject = subject
      @tags = []
      @mentions = {}
      @async = false
    end

    # Public: Tell who/what the rumor is concerning.
    def on object
      @object = object
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
    end

    # Public: Add some tags to the rumor.
    def tag *tags
      @tags << tags
    end

    # Public: Copy a rumor while altering information.
    def copy &alter
      Rumor.new(hash).tap &alter
    end

    # Public: Spread the rumor asynchronously.
    def async async = true
      @async = async
    end

    # Public: Whether this rumor is spread asynchronously.
    def async?
      @async
    end

    # Spread the rumor to all applicable channels.
    #
    # conditions - some conditions on the spreading (Hash).
    #             :only - The channels to spread to (and none other).
    #             :except - The channels not to spread to.
    #
    # Returns nothing.
    def spread conditions = {}
      Rumor.spread Spread.new(self, conditions)
    end

    # Public: Check if the given rumor is a subset of this rumor.
    def matches? rumor
      # Check if subject is a subset.
      _subject = rumor.subject.nil? || rumor.subject == subject
      # Check if from is a subset.
      _from = rumor.from.nil? || rumor.from == from
      # Check if mentions are a subset.
      _mentions = rumors.mentions.all? { |k, v| mentions[k] == v }
      # Check if categories are a subset.
      _tags = (tags | rumor.tags) == categories
      # All those checks must be true
      _subject && _from && _mentions && _categories
    end

    # Public: Rumor in hash form.
    #
    # Returns the rumor converted to a Hash.
    def to_h
      {
        subject: subject,
        object: object,
        mentions: mentions,
        tags: tags,
        async: async?
      }
    end
  end
end
