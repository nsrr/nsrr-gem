# frozen_string_literal: true

require 'nsrr/helpers/json_request'

module Nsrr
  module Helpers
    # Helper to verify that user is authenticated.
    class Authorization
      def self.get_token(token)
        puts  '  Get your token here: ' + "#{Nsrr::WEBSITE}/token".colorize(:blue).on_white.underline
        puts  '  Your input is hidden while entering token.'.colorize(:white)
        print '     Enter your token: '
        token = STDIN.noecho(&:gets).chomp if token.to_s.strip == ''

        (response, _status) = Nsrr::Helpers::JsonRequest.get("#{Nsrr::WEBSITE}/account/#{token}/profile.json")

        if response.is_a?(Hash) && response['authenticated']
          puts 'AUTHORIZED'.colorize(:green) + ' as ' + "#{response['first_name']} #{response['last_name']}".colorize(:white)
        else
          puts 'UNAUTHORIZED'.colorize(:red) + ' Public Access Only'
        end
        token
      end
    end
  end
end
