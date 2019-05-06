# frozen_string_literal: true

require "openssl"
require "net/http"
require "json"
require "cgi"

module Nsrr
  module Helpers
    # Aids in generating JSON requests for GET, POST, and PATCH.
    class JsonRequest
      class << self
        def get(url, *args)
          new(url, *args).get
        end

        def post(url, *args)
          new(url, *args).post
        end

        def patch(url, *args)
          new(url, *args).patch
        end
      end

      attr_reader :url

      def initialize(url, args = {})
        @params = nested_hash_to_params(args)
        @url = URI.parse(url)

        @http = Net::HTTP.new(@url.host, @url.port)
        if @url.scheme == "https"
          @http.use_ssl = true
          @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      rescue
        @error = "Invalid URL: #{url.inspect}"
        puts @error.colorize(:red)
      end

      def get
        return unless @error.nil?
        full_path = @url.path
        query = ([@url.query] + @params).flatten.compact.join("&")
        full_path += "?#{query}" if query.to_s != ""
        response = @http.start do |http|
          http.get(full_path)
        end
        [JSON.parse(response.body), response]
      rescue => e
        puts "GET Error: #{e}".colorize(:red)
      end

      def post
        return unless @error.nil?
        response = @http.start do |http|
          http.post(@url.path, @params.flatten.compact.join("&"))
        end
        [JSON.parse(response.body), response]
      rescue => e
        puts "POST ERROR: #{e}".colorize(:red)
        nil
      end

      def patch
        @params << "_method=patch"
        post
      end

      def nested_hash_to_params(args)
        args.collect do |key, value|
          key_value_to_string(key, value, nil)
        end
      end

      def key_value_to_string(key, value, scope = nil)
        current_scope = (scope ? "#{scope}[#{key}]" : key)
        if value.is_a? Hash
          value.collect do |k,v|
            key_value_to_string(k, v, current_scope)
          end.join("&")
        elsif value.is_a? Array
          value.collect do |v|
            key_value_to_string("", v, current_scope)
          end
        else
          "#{current_scope}=#{CGI.escape(value.to_s)}"
        end
      end
    end
  end
end
