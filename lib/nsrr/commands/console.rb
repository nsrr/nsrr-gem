# frozen_string_literal: true

require 'irb'
require 'irb/completion'
require 'nsrr/models/all'

module Nsrr
  module Commands
    # Allows console to be started with the NSRR environment.
    class Console
      class << self
        def start(*args)
          new(*args).start
        end
      end

      attr_reader :console

      def initialize(_argv)
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
