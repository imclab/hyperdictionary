require "uri"

module Piston
  module Svn
    class Repository < Piston::Repository
      # Register ourselves as a repository handler
      Piston::Repository.add_handler self

      class << self
        def understands_url?(url)
          uri = URI.parse(url)
          case uri.scheme
          when "svn", /^svn\+/
            true
          when "http", "https", "file"
            # Have to contact server to know
            result = svn(:info, url) rescue :failed
            result == :failed ? false : true
          else
            # Don't know how to handle this scheme.
            # Let someone else handle it
          end
        end

        def client
          @@client ||= Piston::Svn::Client.instance
        end

        def svn(*args)
          client.svn(*args)
        end
        
        def repository_type
          'svn'
        end
      end

      def svn(*args)
        self.class.svn(*args)
      end

      def at(revision)
        if revision.respond_to?(:keys) then
          rev = revision[Piston::Svn::REMOTE_REV]
          Piston::Svn::Revision.new(self, rev, revision)
        else
          case
          when revision == :head
            Piston::Svn::Revision.new(self, "HEAD")
          when revision.to_i != 0
            Piston::Svn::Revision.new(self, revision.to_i)
          else
            raise ArgumentError, "Invalid revision argument: #{revision.inspect}"
          end
        end
      end

      def basename
        if self.url =~ /trunk|branches|tags/ then
          self.url.sub(%r{/(?:trunk|branches|tags).*$}, "").split("/").last
        else
          self.url.split("/").last
        end
      end
    end
  end
end
