module Spriteful
  module Actions
    # Public: copies a value to the user clipboard.
    #
    # contents - the String to be copied.
    # Returns nothing.
    def copy(banner, contents)
      # TODO: add support for other Operating Systems.
      IO.popen('/usr/bin/pbcopy', 'w') { |io| io.write(contents) }
      say_status :copied, banner
    end
  end
end
