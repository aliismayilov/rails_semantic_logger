require "active_support/logger"

module ActiveSupport
  # More hacks to try and stop Rails from being it's own worst enemy.
  class Logger
    class << self
      undef :logger_outputs_to?, :broadcast

      if ::Rails::VERSION::STRING < "7.1"
        undef :broadcast
      else
        undef :broadcast_to
      end
    end

    # Prevent Console from trying to merge loggers
    def self.logger_outputs_to?(*args)
      true
    end

    # Prevent broadcasting since SemanticLogger already supports multiple loggers
    def self.broadcast(_logger)
      Module.new
    end

    def self.broadcast_to(_logger)
      Module.new
    end

    def self.new(*args, **kwargs)
      SemanticLogger[self]
    end
  end
end
