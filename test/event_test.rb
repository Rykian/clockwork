require File.expand_path('../../lib/clockwork', __FILE__)
require "minitest/autorun"

describe Clockwork::Event do
  describe '#thread?' do
    before do
      @manager = Class.new
    end

    describe 'manager config thread option set to true' do
      before do
        @manager.stubs(:config).returns({ :thread => true })
      end

      it 'is true' do
        event = Clockwork::Event.new(@manager, nil, nil, nil)
        assert_equal true, event.thread?
      end

      it 'is false when event thread option set' do
        event = Clockwork::Event.new(@manager, nil, nil, nil, :thread => false)
        assert_equal false, event.thread?
      end
    end

    describe 'manager config thread option not set' do
      before do
        @manager.stubs(:config).returns({})
      end

      it 'is true if event thread option is true' do
        event = Clockwork::Event.new(@manager, nil, nil, nil, :thread => true)
        assert_equal true, event.thread?
      end
    end
  end

  describe '#run_now?' do
    before do
      @manager = Class.new
      @manager.stubs(:config).returns({})
    end

    describe 'event skip_first_run option set to true' do
      it 'returns false on first attempt' do
        event = Clockwork::Event.new(@manager, 1, nil, nil, :skip_first_run => true)
        assert_equal false, event.run_now?(Time.now)
      end

      it 'returns true on subsequent attempts' do
        event = Clockwork::Event.new(@manager, 1, nil, nil, :skip_first_run => true)
        # first run
        event.run_now?(Time.now)

        # second run
        assert_equal true, event.run_now?(Time.now + 1)
      end
    end

    describe 'event skip_first_run option not set' do
      it 'returns true on first attempt' do
        event = Clockwork::Event.new(@manager, 1, nil, nil)
        assert_equal true, event.run_now?(Time.now + 1)
      end
    end

    describe 'event skip_first_run option set to false' do
      it 'returns true on first attempt' do
        event = Clockwork::Event.new(@manager, 1, nil, nil, :skip_first_run => false)
        assert_equal true, event.run_now?(Time.now)
      end
    end
  end
end
