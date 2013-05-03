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
    assert_equal Rumor.channel(:example), @channel
  end

  def test_spread_both
    left, right = ExampleChannel.new, ExampleChannel.new
    Rumor.register :left, left
    Rumor.register :right, right
    left.expects(:handle).with(@rumor, anything).once
    right.expects(:handle).with(@rumor, anything).once
    @rumor.spread
  end

  def test_spread_filter
    left, right = ExampleChannel.new, ExampleChannel.new
    Rumor.register :left, left
    Rumor.register :right, right
    left.expects(:handle).with(@rumor, anything).once
    right.expects(:handle).with(@rumor, anything).never
    @rumor.spread only: [:left]
  end

  def test_spread_async
    Rumor.register :example, @channel
    Rumor::Async::Resque.expects(:send_async).with(:example, @rumor).once
    @rumor.spread async: true
  end

  def test_spread_sync_async
    async, sync = ExampleChannel.new, ExampleChannel.new
    Rumor.register :async, async
    Rumor.register :sync, sync, async: false
    ::Resque.expects(:enqueue).once
    sync.expects(:handle).with(@rumor, anything)
    @rumor.spread
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
