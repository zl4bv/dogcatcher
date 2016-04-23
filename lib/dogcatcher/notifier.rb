module Dogcatcher
  # Sends events/notices to the Datadog API and/or a statsd collector.
  class Notifier
    # @param [Dogcatcher::Config] config
    def initialize(config)
      @config = config
    end

    # Sends events/notices to the Datadog API and/or a statsd collector.
    #
    # @param [Dogcatcher::Notice]
    def notify(notice)
      notify_dogapi(notice) if @config.use_dogapi?
      notify_statsd(notice) if @config.use_statsd?
    end

    private

    # @param [Dogcatcher::Notice]
    def notify_dogapi(notice)
      event = Dogapi::Event.new(notice.message,
                                msg_title: notice.title,
                                tags: notice.tags,
                                alert_type: 'error')

      Dogapi::Client.new(@config.api_key).emit_event(event)
    end

    # @param [Dogcatcher::Notice]
    def notify_statsd(notice)
      client = Statsd.new(@config.statsd_host, @config.statsd_port)
      client.event(notice.title,
                   notice.message,
                   tags: notice.tags,
                   alert_type: 'error')
    end
  end
end
