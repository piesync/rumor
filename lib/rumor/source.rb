module Rumor

  # Public: Include this module everywhere you want to be
  # able to rumor. This gives you the benefit that the rumor
  # method can easily be overrided.
  #
  # Exampe:
  #
  #   class Controller
  #     include Rumor::Rumoring
  #
  #     def rumor subject
  #       super.on(current_user)
  #     end
  #
  #     def upgrade
  #       # some code
  #       rumor(:upgraded).mention(plan: :basic).spread only: :kissmetrics
  #     end
  #   end
  #
  module Source

    # Public: Acts as a specialized factory for rumors.
    #
    # Returns a new Rumor.
    def rumor subject = nil
      Rumor::Rumor.new(subject)
    end
  end
end
