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
      if @config.use_dogapi?
        notify_dogapi_event(notice) if @config.send_event
        notify_dogapi_metric(notice) if @config.send_metric
      end
      if @config.use_statsd?
        notify_statsd_event(notice) if @config.send_event
        notify_statsd_metric(notice) if @config.send_metric
      end
    end

    private

    def dogapi_clientl
      @dogapi_client ||= Dogapi::Client.new(@config.api_key)
    end

    def statsd_client
      @statsd_client = Statsd.new(@config.statsd_host, @config.statsd_port)
    end

    # @param [Dogcatcher::Notice]
    def notify_dogapi_event(notice)
      event = Dogapi::Event.new(notice.message,
                                msg_title: notice.title,
                                tags: notice.tags,
                                alert_type: 'error')
      dogapi_client.emit_event(event)
    end

    # @param [Dogcatcher::Notice]
    def notify_dogapi_metric(notice)
      dogapi_client.emit_point(@config.metric_name, 1, tags: notice.tags, type: 'counter' )
    end

    # @param [Dogcatcher::Notice]
    def notify_statsd_event(notice)
      statsd_client.event(notice.title,
                          notice.message,
                          tags: notice.tags,
                          alert_type: 'error')
    end

    # @param [Dogcatcher::Notice]
    def notify_statsd_metric(notice)
      statsd_client.count(@config.metric_name, 1, tags: notice.tags)
    end
  end
end
