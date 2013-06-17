module Spriteful
  module Actions
    # Public: copies a value to the user clipboard.
    #
    # contents - the String to be copied.
    # Returns nothing.
    def copy(contents)
      # TODO: add support for other Operating Systems.
      IO.popen('/usr/bin/pbcopy', 'w') { |io| io.write(contents) }
    end
  end
end
