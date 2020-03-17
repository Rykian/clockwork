require 'test/unit'
require 'mocha/minitest'
require 'fileutils'

class SignalTest < Test::Unit::TestCase
  CMD     = File.expand_path('../../bin/clockwork', __FILE__)
  SAMPLE  = File.expand_path('../samples/signal_test.rb', __FILE__)
  LOGFILE = File.expand_path('../tmp/signal_test.log', __FILE__)

  setup do
    FileUtils.mkdir_p(File.dirname(LOGFILE))
    @pid = spawn(CMD, SAMPLE)
    until File.exist?(LOGFILE)
      sleep 0.1
    end
  end

  teardown do
    FileUtils.rm_r(File.dirname(LOGFILE))
  end

  test 'should gracefully shutdown with SIGTERM' do
    Process.kill(:TERM, @pid)
    sleep 0.2
    assert_equal 'done', File.read(LOGFILE)
  end

  test 'should forcely shutdown with SIGINT' do
    Process.kill(:INT, @pid)
    sleep 0.2
    assert_equal 'start', File.read(LOGFILE)
  end
end

