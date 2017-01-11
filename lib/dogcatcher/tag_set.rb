module Dogcatcher
  # A collection of tags
  class TagSet < Set
    # Returns a copy of self where proc elements are replaced with the
    # result of them being called.
    def compile
      dup.collect! { |el| el.is_a?(Proc) ? el.call : el }
    end

    # Replaces the contents of the tag set with the result of calling
    # {#compile} and returns self.
    def compile!
      replace(compile)
    end
  end
end
