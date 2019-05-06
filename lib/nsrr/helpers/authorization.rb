# frozen_string_literal: true

require "nsrr/helpers/color"
require "nsrr/helpers/json_request"

module Nsrr
  module Helpers
    # Helper to verify that user is authenticated.
    class Authorization
      def self.get_token(token)
        puts  "  Get your token here: " + "#{Nsrr::WEBSITE}/token".bg_gray.blue.underline
        puts  "  Your input is hidden while entering token.".white
        print "     Enter your token: "
        token = STDIN.noecho(&:gets).chomp if token.to_s.strip == ""
        token.strip!
        (response, _status) = Nsrr::Helpers::JsonRequest.get("#{Nsrr::WEBSITE}/api/v1/account/profile.json", auth_token: token)
        if response.is_a?(Hash) && response["authenticated"]
          puts "AUTHORIZED".green + " as " + "#{response["first_name"]} #{response["last_name"]}".white
        else
          puts "UNAUTHORIZED".red + " Public Access Only"
        end
        token
      end
    end
  end
end
