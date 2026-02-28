require "minitest/autorun"
require 'mocha/minitest'
require 'fileutils'

describe "SignalTest" do
  before do
    @command = File.expand_path('../../bin/clockwork', __FILE__)
    @sample = File.expand_path('../samples/signal_test.rb', __FILE__)
    @logfile = File.expand_path('../tmp/signal_test.log', __FILE__)
    FileUtils.mkdir_p(File.dirname(@logfile))
    @pid = spawn(@command, @sample)
    until File.exist?(@logfile)
      sleep 0.1
    end
  end

  after do
    FileUtils.rm_r(File.dirname(@logfile))
  end

  it 'should gracefully shutdown with SIGTERM' do
    Process.kill(:TERM, @pid)
    sleep 0.2
    assert_equal 'done', File.read(@logfile)
  end

  it 'should forcely shutdown with SIGINT' do
    Process.kill(:INT, @pid)
    sleep 0.2
    assert_equal 'start', File.read(@logfile)
  end
end
