require 'spec_helper'

class TestChannel < MiniTest::Unit::TestCase

  class ExampleChannel < Rumor::Channel
    def helper
      "helper"
    end
  end

  def setup
    @channel = ExampleChannel.new
  end

  def test_define_handler
    assert_equal ExampleChannel.handlers, {}
    handle = proc {}
    ExampleChannel.on(:upgrade, &handle)
    assert_equal ExampleChannel.handlers[:upgrade], handle
  end

  def test_send_rumor
    upgrade = proc {}
    install = proc { |rumor| @rumor = rumor }
    ExampleChannel.on(:upgrade, &upgrade)
    ExampleChannel.on(:install, &install)

    @channel.send Rumor::Rumor.new(:install).
      tag(:business).
      on(:cool_user).
      mention(plan: :enterprise)

    rumor = @channel.instance_variable_get :@rumor
    assert rumor.event == :install && rumor.tags == [:business] &&
        rumor.mentions == { plan: :enterprise } && rumor.subject == :cool_user
  end

  def test_use_methods
    ExampleChannel.on(:method_test) do |rumor|
      helper
    end
    @channel.expects(:helper).once
    @channel.send Rumor::Rumor.new(:method_test)
  end

  def teardown
    ExampleChannel.handlers = {}
  end
end
