require 'irb'
require 'irb/completion'
require 'nsrr/models/all'

module Nsrr
  module Commands
    class Console
      class << self
        def start(*args)
          new(*args).start
        end
      end

      attr_reader :console

      def initialize(argv)
        ARGV.clear
        @console = IRB
      end

      def start
        puts "Loading environment (Nsrr #{Nsrr::VERSION::STRING})"
        @console.start
      end

    end
  end
end
