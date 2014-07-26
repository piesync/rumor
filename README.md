# Rumor
[![Build Status](https://secure.travis-ci.org/piesync/rumor.png?branch=master)](http://travis-ci.org/piesync/rumor)
[![Code Climate](https://codeclimate.com/github/piesync/rumor.png)](https://codeclimate.com/github/piesync/rumor)
[![Test Coverage](https://codeclimate.com/github/piesync/rumor/coverage.png)](https://codeclimate.com/github/piesync/rumor)

Need Analytics? Just spread the Rumor! Rumor is made for tracking important events across different channels.

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

## Help and Discussion

If you need help you can contact us by sending a message to:
[oss@piesync.com][mail].

[mail]:   mailto:oss@piesync.com

If you believe you've found a bug, please report it at:
https://github.com/piesync/rumor/issues


## Contributing to Rumor

* Please fork Rumor on github
* Make your changes and send us a pull request with a brief description of your addition
* We will review all pull requests and merge them upon approval

## Copyright

Copyright (c) 2014 PieSync.

