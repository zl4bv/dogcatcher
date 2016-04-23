require 'active_support/backtrace_cleaner'
require 'dogapi'
require 'statsd'

require 'dogcatcher/ext/rake/task'
require 'dogcatcher/config'
require 'dogcatcher/markdown'
require 'dogcatcher/notice'
require 'dogcatcher/notifier'
require 'dogcatcher/version'

module Dogcatcher
  class << self
    # Returns a config instance
    #
    # @return [Dogcatcher::Config]
    def config
      @config ||= Config.new
    end

    # Used to configure Dogcatcher
    #
    # @yieldparam [Dogcatcher::Config]
    def configure
      yield config
    end

    # @param [Exception] exception
    # @return [Dogcatcher::Notice]
    def build_notice(exception)
      Notice.new(config, exception)
    end

    # @param [Dogcatcher::Notice] notice
    def notify(notice)
      @notifier ||= Notifier.new(config)
      @notifier.notify(notice)
    end
  end
end
