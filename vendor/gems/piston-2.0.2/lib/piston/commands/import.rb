require "piston/commands/base"

module Piston
  module Commands
    class Import < Piston::Commands::Base
      attr_reader :options

      def repository_type
        options[:repository_type]
      end

      def select_repository(repository_url)
        if repository_type then
          logger.info {"Forced repository type to #{repository_type}"}
          repository_class_name = "Piston::#{repository_type.downcase.capitalize}::Repository"
          repository_class = repository_class_name.constantize
          repository_class.new(repository_url)
        else
          logger.info {"Guessing the repository type"}
          Piston::Repository.guess(repository_url)
        end
      end

      def run(repository_url, target_revision, wcdir)
        repository = select_repository(repository_url)
        revision = repository.at(target_revision)

        wcdir = File.expand_path(wcdir.nil? ? repository.basename : wcdir)
        logger.info {"Guessing the working copy type"}
        logger.debug {"repository_url: #{repository_url.inspect}, target_revision: #{target_revision.inspect}, wcdir: #{wcdir.inspect}"}
        working_copy = guess_wc(wcdir)

        if working_copy.exist? && !force then
          logger.fatal "Path #{working_copy} already exists and --force not given.  Aborting..."
          abort
        end
        
        working_copy.import(revision, options[:lock])
        logger.info {"Imported #{revision} from #{repository}"}
      end

      def start(*args)
        repository_url = args.shift
        wcdir          = args.shift

        raise ArgumentError, "Required REPOSITORY argument missing" if repository_url.blank?

        begin
          self.run(repository_url, options[:revision] || options[:commit] || :head, wcdir)
        rescue Piston::Repository::UnhandledUrl => e
          supported_types = Piston::Repository.handlers.collect do |handler|
            handler.repository_type
          end
          puts "Unsure how to handle:"
          puts "\t#{repository_url.inspect}."
          puts "You should try using --repository-type. Supported types are:"
          supported_types.each do |type|
            puts "\t#{type}"
          end

          exit 1
        end
      end
    end
  end
end
