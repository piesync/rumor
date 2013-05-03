require 'spec_helper'

class TestRumorRumor < MiniTest::Unit::TestCase

  def test_spread_async
    ::Rumor.expects(:spread_async).with do |rumor|
      rumor.time - Time.now.utc > -3
    end
    rumor = Rumor::Rumor.new(:upgrade).mention price: 8
    rumor.spread
  end

  def test_spread
    ::Rumor.expects(:spread).with do |rumor|
      rumor.time - Time.now.utc > -3
    end
    rumor = Rumor::Rumor.new(:upgrade).mention price: 8
    rumor.spread async: false
  end
end
