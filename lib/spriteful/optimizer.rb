require 'image_optim'

module Spriteful
  # Internal: Wrapper class for the `ImageOptim` gem that can
  # optimize PNG images and won't crash if no PNG optimizer is
  # presented.
  class Optimizer
    # Public: Initializes the Optimizer, checking for missing
    # optimizers that should be ignored when optimizing the image.
    def initialize
      @optimizer = ImageOptim.new(optimization_options)
    end

    # Public: Optimizes and replaces the given path.
    #
    # Returns nothing.
    def optimize!(path)
      @optimizer.optimize_image!(path)
    end

    # Public: Returns true if any optimization can be executed
    # of if the `optimize!` will be a no-op.
    #
    # Returns true or false.
    def enabled?
      optimization_options.values.any?
    end

    private
    # Internal: Maps which optimizers (or 'workers') that
    # are missing from the system and should be ignored by
    # the `ImageOptim` optimizer.
    #
    # Returns a Hash.
    def optimization_options
      @options ||= {
        pngcrush: command_exists?(:pngcrush),
        pngout: command_exists?(:pngout),
        optipng: command_exists?(:optipng),
        advpng: command_exists?(:advpng)
      }
    end

    # Internal: Checks if a command exists.
    #
    # Returns true or false.
    def command_exists?(command)
      `command -v #{command}` && $?.success?
    end
  end
end