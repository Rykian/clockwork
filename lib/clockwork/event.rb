module Clockwork
  class Event
    attr_accessor :job, :last

    def initialize(manager, period, job, block, options = {})
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

    def convert_timezone(time)
      @timezone ? time.in_time_zone(@timezone) : time
    end

    def run_now?(time)
      time = convert_timezone(time)
      return false unless elapsed_ready?(time)
      return false unless run_at?(time)
      return false unless run_if?(time)

      true
    end

    def thread?
      @thread
    end

    def run(time)
      @manager.log "Triggering '#{self}'"
      @last = convert_timezone(time)

      if thread?
        if @manager.thread_available?
          thread = Thread.new { execute }
          thread['creator'] = @manager
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
    rescue StandardError => e
      error = e
      @manager.log_error e
      @manager.handle_error(@job, e)
    ensure
      finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      duration = ((finish - start) * 1000).round # milliseconds

      @manager.log "Finished '#{self}' duration_ms=#{duration} error=#{error.inspect}"
    end

    def elapsed_ready?(time)
      @last.nil? || (time - @last.to_i).to_i >= @period
    end

    def run_at?(time)
      @at.nil? || @at.ready?(time)
    end

    def run_if?(time)
      @if.nil? || @if.call(time)
    end

    def validate_if_option(if_option)
      return unless if_option && !if_option.respond_to?(:call)

      raise ArgumentError, ':if expects a callable object, but `if_option` does not respond to call'
    end
  end
end
