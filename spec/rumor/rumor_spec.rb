require 'spec_helper'

class TestRumorRumor < MiniTest::Unit::TestCase

  def test_spread
    ::Rumor.expects(:spread).with do |rumor, options|
      rumor.time - Time.now.utc > -3 &&
        options[:async] == false
    end
    rumor = Rumor::Rumor.new(:upgrade).mention price: 8
    rumor.spread async: false
  end
end
