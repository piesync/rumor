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
  #       super.from(current_user)
  #     end
  #
  #     def upgrade
  #       # some code
  #       rumor(:upgraded).mention(plan: :basic).spread only: :kissmetrics
  #     end
  #   end
  #
  module Rumoring

    # Public: Acts as a specialized factory for rumors.
    #
    # Returns a new Rumor.
    def rumour subject
      Rumor::Rumor.new(subject)
    end
  end
end
