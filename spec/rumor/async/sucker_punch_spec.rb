require 'spec_helper'
require 'sucker_punch/testing/inline'

class TestRumorRumor < MiniTest::Unit::TestCase

  def test_send_async
    channel_name = :channel_name
    rumor = "rumor-double"

    Rumor::Async::SuckerPunch::Job.any_instance.expects(:perform).with(channel_name, rumor).once

    Rumor::Async::SuckerPunch.send_async(channel_name, rumor)
  end

end
