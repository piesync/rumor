module Rumor

  # Public: A Router is a special kind of channel that
  # routes rumors to other channels using matchers.
  #
  # The matching is done by providing a Rumor object
  # as a matcher. The matcher then matches a the Rumors
  # that specify equally or more information than that is begin matched.
  #
  # For example, A Rumor with categories: ['business'] would match a Rumor
  # with categories ['business', 'warning'] but not one wihtout categories.
  #
  # Example:
  #
  #   Router.new do
  #     match categories: [:business] do |rumor|
  #       rumor.channel(:kissmetrics)
  #     end
  #   end
  #
  class Router

    # Public: Create a new matcher in the router.
    # When no attributes are given, the matcher matches every Rumor.
    #
    # attributes - Rumor attributes used for building the matcher rumor.
    #
    # Returns nothing
    def match attributes
    end

    # Internal: Channels a Rumor based on its matchers.
    def route spread
    end
  end
end
