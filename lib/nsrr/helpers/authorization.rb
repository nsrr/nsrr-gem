require 'nsrr/helpers/json_request'

module Nsrr
  module Helpers
    class Authorization
      def self.get_token(token)
        puts  "  Get your token here: " + "#{Nsrr::WEBSITE}/token".colorize( :blue ).on_white.underline
        puts  "  Your input is hidden while entering token.".colorize(:white)
        print "     Enter your token: "
        token = STDIN.noecho(&:gets).chomp if token.to_s.strip == ''

        response = Nsrr::Helpers::JsonRequest.get("#{Nsrr::WEBSITE}/account/#{token}/profile.json")

        if response.kind_of?(Hash) and response['authenticated']
          puts "AUTHORIZED".colorize(:green) + " as " + "#{response['first_name']} #{response['last_name']}".colorize( :white )
        else
          puts "UNAUTHORIZED".colorize(:red) + " Public Access Only"
        end
        token
      end
    end
  end
end
