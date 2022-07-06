module Clockwork
  class At
    class FailedToParse < StandardError; end

    NOT_SPECIFIED = nil
    WDAYS = %w[
      sunday monday tuesday wednesday thursday friday saturday
    ].each.with_object({}).with_index do |(w, wdays), index|
      [w, w.capitalize, w[0...3], w[0...3].capitalize].each do |k|
        wdays[k] = index
      end
    end

    def self.parse(at)
      return unless at

      case at
      when /\A([[:alpha:]]+)\s(.*)\z/
        raise FailedToParse, at unless (wday = WDAYS[Regexp.last_match(1)])

        parsed_time = parse(Regexp.last_match(2))
        parsed_time.wday = wday
        parsed_time
      when /\A(\d{1,2}):(\d\d)\z/
        new(Regexp.last_match(2).to_i, Regexp.last_match(1).to_i)
      when /\A\*{1,2}:(\d\d)\z/
        new(Regexp.last_match(1).to_i)
      when /\A(\d{1,2}):\*\*\z/
        new(NOT_SPECIFIED, Regexp.last_match(1).to_i)
      else
        raise FailedToParse, at
      end
    rescue ArgumentError
      raise FailedToParse, at
    end

    attr_accessor :min, :hour, :wday

    def initialize(min, hour = NOT_SPECIFIED, wday = NOT_SPECIFIED)
      @min = min
      @hour = hour
      @wday = wday
      raise ArgumentError unless valid?
    end

    def ready?(time)
      (@min == NOT_SPECIFIED or time.min == @min) and
        (@hour == NOT_SPECIFIED or time.hour == @hour) and
        (@wday == NOT_SPECIFIED or time.wday == @wday)
    end

    def ==(other)
      @min == other.min && @hour == other.hour && @wday == other.wday
    end

    private

    def valid?
      @min == NOT_SPECIFIED || (0..59).cover?(@min) &&
        @hour == NOT_SPECIFIED || (0..23).cover?(@hour) &&
          @wday == NOT_SPECIFIED || (0..6).cover?(@wday)
    end
  end
end
