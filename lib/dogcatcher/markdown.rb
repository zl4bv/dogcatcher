module Dogcatcher
  # Produces a string formatted as Markdown.
  class Markdown
    def initialize
      @result = []
    end

    # Adds a bullet point to the result string.
    #
    # @param [String] str text to include next to the bullet point
    def bullet(str)
      @result << ['* ', str, "\n"]
    end

    # Adds a code block to the result string.
    #
    # @param [String] str text to include in the code block
    # @param [String] language of the code block
    def code_block(str, language = nil)
      @result << ['```', language, "\n", str, "\n```\n"]
    end

    # Gets the result string formatted in Markdown.
    #
    # @return [String]
    def result
      ['%%%', "\n", *@result, "\n", '%%%'].join('')
    end
  end
end
