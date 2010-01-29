module Piston
  module Commands
    class Base
      class << self
        def logger
          @@logger ||= Log4r::Logger["main"]
        end
      end

      attr_reader :options

      def initialize(options={})
        @options = options
        logger.debug {"#{self.class.name} with options #{options.inspect}"}
      end

      def verbose
        @options[:verbose]
      end

      def force
        @options[:force]
      end

      def quiet
        @options[:quiet]
      end

      def logger
        self.class.logger
      end
      
      def guess_wc(wcdir)
        Piston::WorkingCopy.guess(wcdir)
      end
      
      def working_copy!(wcdir)
        wc = guess_wc(wcdir)
        wc.validate!
        wc
      end
    end
  end
end
