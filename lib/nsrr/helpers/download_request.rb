# frozen_string_literal: true

require "openssl"
require "net/http"
require "uri"

module Nsrr
  module Helpers
    # Downloads a file to a specified folder.
    class DownloadRequest
      class << self
        def get(*args)
          new(*args).get
        end
      end

      attr_reader :url, :error, :file_size

      def initialize(url, download_folder)
        @url = URI.parse(url)
        @http = Net::HTTP.new(@url.host, @url.port)
        if @url.scheme == "https"
          @http.use_ssl = true
          @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        @download_folder = download_folder
        @file_size = 0
      end

      # Writes file segments to disk immediately instead of storing in memory
      def get
        return unless @error.nil?
        local_file = ::File.open(@download_folder, "wb")
        partial = true
        @http.request_get(@url.path) do |response|
          case response.code
          when "200"
            response.read_body do |segment|
              local_file.write(segment)
            end
            @file_size = ::File.size(@download_folder)
            partial = false
          when "302"
            @error = "Token Not Authorized to Access Specified File"
          else
            @error = "#{response.code} #{response.class.name}"
          end
        end
      rescue => e # Net::ReadTimeout, SocketError
        @error = "(#{e.class}) #{e.message}"
      ensure
        local_file.close if local_file
        ::File.delete(@download_folder) if partial && ::File.exist?(@download_folder)
      end
    end
  end
end
