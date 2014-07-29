require 'openssl'
require 'net/http'
require 'uri'

module Nsrr
  module Helpers
    class DownloadRequest
      class << self
        def get(*args)
          new(*args).get
        end
      end

      attr_reader :url, :error, :file_size

      def initialize(url, download_folder)
        begin
          escaped_url = URI.escape(url)
          @url = URI.parse(escaped_url)
          @http = Net::HTTP.new(@url.host, @url.port)
          if @url.scheme == 'https'
            @http.use_ssl = true
            @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          @download_folder = download_folder
          @file_size = 0
        rescue => e
          @error = 'Invalid Token'
        end
      end

      def get
        req = Net::HTTP::Get.new(@url.path)
        response = @http.start do |http|
          http.request(req)
        end
        case response.code when '200'
          ::File.open(@download_folder, 'wb') do |local_file|
            local_file.write( response.body )
          end
          @file_size = ::File.size(@download_folder)
        when '302'
          @error = 'Token Not Authorized to Access Specified File'
        else
          @error = "#{response.code} #{response.class.name}"
        end
      end
    end
  end
end


