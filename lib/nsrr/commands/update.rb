# frozen_string_literal: true

require "nsrr/helpers/color"
require "nsrr/helpers/json_request"

module Nsrr
  module Commands
    # Command to check if there is an updated version of the gem available.
    class Update
      class << self
        def start(*args)
          new(*args).start
        end
      end

      def initialize(argv)
      end

      def start
        (json, _status) = Nsrr::Helpers::JsonRequest.get("https://rubygems.org/api/v1/gems/nsrr.json")
        if json
          if json["version"] == Nsrr::VERSION::STRING
            puts "The nsrr gem is " + "up-to-date".green + "!"
          else
            puts
            puts "A newer version (v#{json["version"]}) is available! Type the following command to update:"
            puts
            puts "  gem install nsrr --no-document".white
            puts
          end
        else
          puts "Unable to connect to RubyGems.org. Please try again later."
        end
      end
    end
  end
end
