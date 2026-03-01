module Clockwork
  class Event
    attr_accessor :job, :last

    def initialize(manager, period, job, block, options={})
      validate_if_option(options[:if])
      @manager = manager
      @period = period
      @job = job
      @at = At.parse(options[:at])
      @block = block
      @if = options[:if]
      @thread = options.fetch(:thread, @manager.config[:thread])
      @timezone = options.fetch(:tz, @manager.config[:tz])
      @skip_first_run = options[:skip_first_run]
      @last = @skip_first_run ? convert_timezone(Time.now) : nil
    end

    def convert_timezone(t)
      @timezone ? t.in_time_zone(@timezone) : t
    end

    def run_now?(t)
      t = convert_timezone(t)
      return false unless elapsed_ready?(t)
      return false unless run_at?(t)
      return false unless run_if?(t)
      true
    end

    def thread?
      @thread
    end

    def run(t)
      @manager.log "Triggering '#{self}'"
      @last = convert_timezone(t)
      if thread?
        if @manager.thread_available?
          t = Thread.new do
            execute
          end
          t['creator'] = @manager
        else
          @manager.log_error "Threads exhausted; skipping #{self}"
        end
      else
        execute
      end
    end

    def to_s
      job.to_s
    end

    private
    def execute
      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      error = nil

      @block.call(@job, @last)
    rescue => e
      error = e
      @manager.log_error e
      @manager.handle_error e
    ensure
      finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      duration = ((finish - start) * 1000).round # milliseconds

      @manager.log "Finished '#{self}' duration_ms=#{duration} error=#{error.inspect}"
    end

    def elapsed_ready?(t)
      # We only need to calculate this if the period is >= 1 day. The UTC offset check only makes sense
      # for periods >= 1.day since these are the shortest period where increasing the date by a day, may not
      # exactly match the exact elapsed time.
      change_in_utc_offset = if @period >= 1.day
        t.utc_offset - (t - @period).utc_offset
      else
        0
      end
      @last.nil? || (t - @last.to_i).to_i >= (@period - change_in_utc_offset)
    end

    def run_at?(t)
      @at.nil? || @at.ready?(t)
    end

    def run_if?(t)
      @if.nil? || @if.call(t)
    end

    def validate_if_option(if_option)
      return unless if_option
      unless if_option.respond_to?(:call) && if_option.respond_to?(:arity) && if_option.arity == 1
        raise ArgumentError.new(':if expects a callable object that accepts a single argument, but #{if_option} is not')
      end
    end
  end
end
