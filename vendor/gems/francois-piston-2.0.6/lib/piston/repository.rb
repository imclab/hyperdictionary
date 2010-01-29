require "piston/revision"

module Piston
  class Repository
    class UnhandledUrl < RuntimeError; end

    class << self
      def logger
        @@logger ||= Log4r::Logger["handler"]
      end

      def guess(url)
        logger.info {"Guessing the repository type of #{url.inspect}"}
        
        handler = handlers.detect do |handler|
          logger.debug {"Asking #{handler}"}
          handler.understands_url?(url)
        end
        
        raise UnhandledUrl unless handler
        
        handler.new(url)
      end

      @@handlers = Array.new
      def add_handler(handler)
        @@handlers << handler
      end

      def handlers
        @@handlers
      end
    end

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def logger
      self.class.logger
    end

    def at(revision)
      raise SubclassResponsibilityError, "Piston::Repository#at should be implemented by a subclass."
    end

    def to_s
      @url
    end

    def inspect
      "Piston::Repository(#{@url})"
    end
    
    def ==(other)
      url == other.url
    end
  end
end
