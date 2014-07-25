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
        @http.use_ssl = true if (@url.scheme == 'https')
      end

      def get
        puts "Accessing: #{@url.to_s}"
        req = Net::HTTP::Get.new(@url.path)
        response = @http.start do |http|
          http.request(req)
        end
        JSON.parse(response.body) rescue nil
      end
    end
  end
end


