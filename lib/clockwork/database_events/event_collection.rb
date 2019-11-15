module Clockwork
  module DatabaseEvents
    class EventCollection
      def initialize(manager=Clockwork.manager)
        @events = []
        @manager = manager
      end

      def add(event)
        @events << event
      end

      def has_changed?(model)
        return true if event.nil?

        ignored_attributes = model.ignored_attributes if model.respond_to?(:ignored_attributes)
        ignored_attributes ||= []

        model_attributes = model.attributes.select do |k, _|
          not ignored_attributes.include?(k.to_sym)
        end

        event.model_attributes != model_attributes
      end

      def unregister
        events.each{|e| manager.unregister(e) }
      end

      private

      attr_reader :events, :manager

      # All events in the same collection (for a model instance) are equivalent
      # so we can use any of them. Only their @at variable will be different,
      # but we don't care about that here.
      def event
        events.first
      end
    end
  end
end
