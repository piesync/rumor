require 'spec_helper'

class TestChannel < MiniTest::Unit::TestCase

  class ExampleChannel < Rumor::Channel
  end

  def setup
    @channel = ExampleChannel.new
    @rumor = Rumor::Rumor.new(:install).
      tag(:business).
      on(:cool_user).
      mention(plan: :enterprise)
  end

  def test_define_handler
    assert_equal ExampleChannel.handlers, {}
    handle = proc {}
    ExampleChannel.on(:upgrade, &handle)
    assert_equal ExampleChannel.handlers[:upgrade], handle
  end

  def test_send_rumor
    upgrade = proc {}
    install = proc {}
    ExampleChannel.on(:upgrade, &upgrade)
    ExampleChannel.on(:install, &install)

    install.expects(:call).with do |rumor|
      rumor.event == :install&& rumor.tags == [:business] &&
        rumor.mentions == { plan: :enterprise } && rumor.subject == :cool_user
    end

    @channel.send @rumor
  end

  def teardown
    ExampleChannel.handlers = {}
  end
end
