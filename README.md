# Rumor

All event processing is done asynchronously. Different adapters can be used to handle the processing (currently only Resque, default).

## Usage

### Let those controllers rumor

**First**

Add rumor capabilities to your controller by adding `include Rumor::Source`.

**Then**

Add rumor instructions in your controller methods.

```ruby
# Rumor about an event.
rumor(:upgrade).on('john').mention(plan: plan.id).tag(:important).spread
# Rumor only to certain channels.
# Rumor whatever you want.
rumor(:profit).tag(:finally).spread only: [:mixpanel]
```

**Where does the rumor come from?**

The `rumor` method is a regular method defined in your controller (defined by including `Source`). You can use it to add default values to your rumors.

```ruby
class AccountController
  include Rumor::Source

  def rumor event
    super(event).on(current_user.id).tag(:accounts)
  end
end
```

### Adding Rumor Channels

```ruby
class MixpanelChannel < Rumor::Channel

  # This is just a regular class.
  def initialize tracker
    @tracker = tracker
  end

  # Matches only upgrade events with the important tag.
  on(:upgrade) do |rumor|
    rumor.subject # => 'john'
    rumor.tag # => [:important]
    plan = Plan.find rumor.mentions[:plan]
    @tracker.track 'Upgraded Account', to: plan.name
  end
end

# Register the channel.
tracker = Mixpanel::Tracker.new Environment::MIXPANEL_TOKEN,
Rumor.register :mixpanel, MixpanelChannel.new tracker
```
