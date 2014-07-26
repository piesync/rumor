require 'minitest/autorun'
require 'mocha/setup'

require 'rumor'
require 'rumor/async/resque'
require 'rumor/async/sucker_punch'

Rumor.async_handler = Rumor::Async::Resque

require 'sucker_punch/testing/inline'
Resque.inline = true

