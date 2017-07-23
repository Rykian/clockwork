require 'clockwork'
require 'active_support/time'

module Clockwork
  LOGFILE = File.expand_path('../../tmp/signal_test.log', __FILE__)

  handler do |job|
    File.write(LOGFILE, 'start')
    sleep 0.1
    File.write(LOGFILE, 'done')
  end

  configure do |config|
    config[:sleep_timeout] = 0
    config[:logger] = Logger.new(StringIO.new)
  end

  every(1.seconds, 'run.me.every.1.seconds')
end

