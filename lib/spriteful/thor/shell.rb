module Spriteful
  module Thor
    # Internal: Wraps the 'Thor::Shell' API into a nullable proxy
    # so the Spriteful internal code can access 'Spriteful.shell'
    # without worrying of the presence of the shell or not.
    class Shell
      def wrap(shell)
        @shell = shell
      end

      def say_path(status, path)
        say_status status, Pathname.new(path).relative_path_from(Pathname.new(Dir.pwd))
      end

      ::Thor::Shell::SHELL_DELEGATED_METHODS.each do |method|
        module_eval <<-METHOD, __FILE__, __LINE__
          def #{method}(*args,&block)
            if @shell.respond_to?(:#{method})
              @shell.#{method}(*args,&block)
            end
          end
        METHOD
      end
    end
  end
end
