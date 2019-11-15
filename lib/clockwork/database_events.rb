require 'clockwork/database_events/event'
require 'clockwork/database_events/synchronizer'
require 'clockwork/database_events/event_collection'
require 'clockwork/database_events/event_store'
require 'clockwork/database_events/manager'

# TERMINOLOGY
#
# For clarity, we have chosen to define terms as follows for better communication in the code, and when
# discussing the database event implementation.
#
# "Event":      "Native" Clockwork events, whether Clockwork::Event or Clockwork::DatabaseEvents::Event
# "Model":      Database-backed model instances representing events to be created in Clockwork

module Clockwork
  module Methods
    def sync_database_events(options={}, &block)
      DatabaseEvents::Synchronizer.setup(options, &block)
    end
  end

  extend Methods

  module DatabaseEvents
  end
end
