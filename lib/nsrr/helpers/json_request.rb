require 'openssl'
require 'net/http'
require 'json'

module Nsrr
  module Helpers
    class JsonRequest
      class << self
        def get(*args)
          new(*args).get
        end
      end

      attr_reader :url

      def initialize(url)
        @url = URI.parse(url)
        @http = Net::HTTP.new(@url.host, @url.port)
        if @url.scheme == 'https'
          @http.use_ssl = true
          @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end

      def get
        req = Net::HTTP::Get.new(@url.path)
        response = @http.start do |http|
          http.request(req)
        end
        JSON.parse(response.body) rescue nil
      end
    end
  end
end


