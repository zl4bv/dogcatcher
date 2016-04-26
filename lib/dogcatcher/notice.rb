module Dogcatcher
  class Notice
    # Name of the source that caught the exception
    attr_accessor :notifier

    # Name of the action that caused the exception
    attr_accessor :action

    # Additional information about the exception
    attr_accessor :metadata

    # The exception itself
    attr_reader :exception

    # @param [Dogcatcher::Config] config
    # @param [Exception] exception
    def initialize(config, exception)
      @config = config
      @exception = exception
      @metadata = {}
    end

    # Markdown-formatted message containing the backtrace and metadata.
    #
    # @return [String]
    def message
      backtrace = @config.backtrace_cleaner.clean(exception.backtrace)
      markdown = Markdown.new
      metadata.each { |key, value| markdown.bullet("#{key}: #{value}") }
      markdown.code_block(backtrace.join("\n"))
      markdown.result
    end

    # Tags containing information about the event. If gem version tags are
    # enabled then they will be included in the output.
    #
    # @return [Array<String>]
    def tags
      arr = []
      arr << "notifier:#{notifier}"
      arr << "action:#{action}"
      arr << "exception_class:#{exception.class}"
      arr << gem_tags if @config.gem_tags
      arr.flatten
    end

    # Title of the event/notice.
    #
    # Includes the program name if a program name is configured.
    #
    # @return [String]
    def title
      program = "#{@config.program} - " if @config.program
      "#{program}#{exception.class}:#{exception.message}"
    end

    private

    # Searches for gem versions in the backtrace and derives tags from them.
    #
    # @return [Array<String>]
    def gem_tags
      exception.backtrace.map do |line|
        match = line.scan(%r{gems/[A-Za-z0-9\-_.]+/gems/([A-Za-z\-_]+)-([0-9.]+(\.[a-z]+(\.[0-9]+)?)?)/})
        match.empty? ? nil : match.flatten.compact.join(':')
      end.compact
    end
  end
end
