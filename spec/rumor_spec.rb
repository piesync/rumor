require 'spec_helper'

class TestRumor < MiniTest::Unit::TestCase

  class ExampleChannel
    include Rumor::Channel
  end

  def setup
    @channel = ExampleChannel.new
    @rumor = Rumor::Rumor.new(:upgrade).mention price: 8
  end

  def test_channels_initialized
    assert_equal Rumor.channels, {}
  end

  def test_add_channel
    Rumor.register :example, @channel
    assert_equal Rumor.channels[:example], @channel
  end

  def test_spread_both
    left, right = ExampleChannel.new, ExampleChannel.new
    Rumor.register :left, left
    Rumor.register :right, right
    left.expects(:send).with(@rumor).once
    right.expects(:send).with(@rumor).once
    Rumor.spread @rumor
  end

  def test_spread_filter
    left, right = ExampleChannel.new, ExampleChannel.new
    @rumor.stubs(:to?).with(:left).returns true
    @rumor.stubs(:to?).with(:right).returns false
    Rumor.register :left, left
    Rumor.register :right, right
    left.expects(:send).with(@rumor).once
    right.expects(:send).with(@rumor).never
    Rumor.spread @rumor
  end

  def test_spread_async
    Rumor::Async::Resque.expects(:spread_async).with(@rumor).once
    Rumor.spread_async @rumor
  end

  def teardown
    Rumor.channels = {}
  end
end
