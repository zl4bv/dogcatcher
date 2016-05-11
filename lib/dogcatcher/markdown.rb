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
    # @param [FixNum] max_len Length at which to truncate the content of the
    #   code block. Length includes block backticks and language. Negative
    #   numbers disable the maximum length.
    def code_block(str, language = nil, max_len = -1)
      if max_len > 0
        max_len -= code_block_builder('', language).length # Subtract markdown overhead
        str = str[0..max_len-1] if str.length > max_len
      end
      @result << code_block_builder(str, language)
    end

    # Gets the result string formatted in Markdown.
    #
    # @return [String]
    def result
      ['%%%', "\n", *@result, "\n", '%%%'].join('')
    end

    private

    def code_block_builder(str, language)
      ['```', language, "\n", str, "\n```\n"].join('')
    end
  end
end
