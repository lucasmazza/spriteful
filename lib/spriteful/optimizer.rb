require 'image_optim'

module Spriteful
  # Internal: Wrapper class for the `ImageOptim` gem that can
  # optimize PNG images and won't crash if no PNG optimizer is
  # presented.
  class Optimizer
    # Public: Initializes the Optimizer, checking for missing
    # optimizers that should be ignored when optimizing the image.
    def initialize
      @workers = ImageOptim::Worker.klasses.map { |k| k.name.split('::').last.downcase }
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

    # Private: Gets a list of supported optimizers.
    def optimizers
      @workers.select { |w| supported_worker?(w) }
    end

    private
    # Internal: Maps which optimizers (or 'workers') that
    # are missing from the system and should be ignored by
    # the `ImageOptim` optimizer.
    #
    # Returns a Hash.
    def optimization_options
      @options ||= @workers.each_with_object({}) do |worker, hash|
        hash[worker.to_sym] = supported_worker?(worker) && command_exists?(worker)
      end
    end

    def supported_worker?(worker)
      !!(worker =~ /png/i)
    end

    # Internal: Checks if a command exists.
    #
    # Returns true or false.
    def command_exists?(command)
      ENV['PATH'].split(File::PATH_SEPARATOR).any? do |root|
        path = File.join(root, command)
        File.executable?(path) && File.file?(path)
      end
    end
  end
end
