require 'spec_helper'

class TestRumor < MiniTest::Unit::TestCase
  include Rumor::Source

  class ExampleChannel < Rumor::Channel
  end

  class IntegrationChannel < Rumor::Channel
    def initialize delegate
      @delegate = delegate
    end

    on(:upgrade) do |rumor|
      @delegate.upgrade
    end

    on(:install) do |rumor|
      @delegate.install
    end
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

  def test_integration
    channel1 = mock
    Rumor.register :channel1, IntegrationChannel.new(channel1)
    channel1.expects(:upgrade)
    rumor(:upgrade).mention(plan: :enterprise).spread
  end

  def teardown
    Rumor.channels = {}
  end
end
