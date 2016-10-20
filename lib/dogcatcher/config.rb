module Dogcatcher
  # Configuration for Dogcatcher
  class Config
    # Optional program name that will be included in the event information.
    attr_accessor :program

    # Datadog API key.
    #
    # This must be configured in order to sent events to the Datadog API.
    attr_accessor :api_key

    # The host and port where statsd events will be sent.
    #
    # By default the host is +127.0.0.1+ and the port is +8125+.
    attr_accessor :statsd_host
    attr_accessor :statsd_port

    # When each is set to +true+ then exceptions will be sent via the
    # corresponding method. Both can be enabled/disabled at the same time.
    #
    # By default these are unset; dogapi will be used if an API key is provided
    # else statsd will be used.
    attr_accessor :use_dogapi
    attr_accessor :use_statsd

    # When true, a metric will be sent via the enabled method.
    attr_accessor :send_metric
    # When true, an event will be sent via the enabled method.
    attr_accessor :send_event

    # Name of the metric that will be sent
    attr_accessor :metric_name

    # When enabled it will add tags for each +gem_name:version+ found in the
    # backtrace.
    #
    # Enabled by default.
    attr_accessor :gem_tags

    # Used to clean the backtrace.
    #
    # By default it does no cleaning.
    attr_accessor :backtrace_cleaner

    # Custom tags to send with exception events
    attr_accessor :custom_tags

    DEFAULT_METRIC_NAME = 'dogcatcher.errors.count'

    def initialize
      @statsd_host = '127.0.0.1'
      @statsd_port = 8125
      @gem_tags = true
      @backtrace_cleaner = ActiveSupport::BacktraceCleaner.new
      @custom_tags = []
      @send_metric = true
      @send_event = true
      @metric_name = DEFAULT_METRIC_NAME
    end

    # Adds a backtrace filter. The given line in the backtrace will be replaced
    # with the line returned by the given block.
    #
    # @yieldparam [String] line in the backtrace
    # @yieldreturn [String] filtered line in the backtrace
    def add_filter
      backtrace_cleaner.add_filter { |line| yield line }
    end

    # Adds a backtrace silencer. Excludes the given line from the backtrace if
    # the given block returns +true+.
    #
    # @yieldparam [String] line in the backtrace
    # @yieldreturn [Boolean] true if the line should be excluded
    def add_silencer
      backtrace_cleaner.add_silencer { |line| yield line }
    end

    # Whether to send events to the Datadog API.
    #
    # If {#use_dogapi} is +nil+ (the default), then this will return +true+ if
    # a Datadog API key is set.
    #
    # @return [Boolean] true if events should be sent to the Datadog API
    def use_dogapi?
      return !@api_key.nil? if @use_dogapi.nil?

      @use_dogapi
    end

    # Whether to send events to a statsd collector.
    #
    # If {#use_dogapi} is +nil+ (the default), then this will return +false+ if
    # a Datadog API key is set.
    #
    # @return [Boolean] true if events should be sent to a statsd collector
    def use_statsd?
      return @api_key.nil? if @use_statsd.nil?

      @use_statsd
    end
  end
end
