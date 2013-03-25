require 'minitest/autorun'
require 'mocha/setup'

require 'rumor'
require 'rumor/async/resque'

Resque.inline = true
