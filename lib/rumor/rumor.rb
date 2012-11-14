module Rumor

  # Public: A Rumor represents an event that manifests itself
  # in a program. An event frequently describes an action
  # that a user has executed.
  class Rumor

    # Public: A rumor has a subject, the event name.
    # this is required for every rumor.
    attr_accessor :subject

    # Public: The starter of the rumor.
    # This is mostly the user that executed the event.
    attr_accessor :from

    # Public: The mentions of the rumor.
    # All the information a rumor mentions about an event.
    attr_accessor :mentions

    # Public: Every rumor has some categories.
    # A Rumor can be categorized in multiple optional categories.
    attr_accessor :categories

    # Public: Creates a new rumor.
    #
    # attributes - Attributes of the rumor (Hash), subject is required
    def initialize attributes
    end

    # Public: Copy a rumor while altering information.
    def copy &alter
      Rumor.new(hash).tap &alter
    end

    # Public: Check if the given rumor is a subset of this rumor.
    def >= rumor
      # Check if subject is a subset.
      _subject = rumor.subject.nil? || rumor.subject == subject
      # Check if from is a subset.
      _from = rumor.from.nil? || rumor.from == from
      # Check if mentions are a subset.
      _mentions = rumors.mentions.all? { |k, v| mentions[k] == v }
      # Check if categories are a subset.
      _categories = (categories | rumor.categories) == categories
      # All those checks must be true
      _subject && _from && _mentions && _categories
    end

    # Public: Rumor in hash form.
    #
    # Returns the rumor converted to a Hash.
    def hash
      {
        subject: subject,
        from: from,
        mentions: mentions,
        categories: categories
      }
    end
  end
end
