# frozen_string_literal: true

require "colorize"
require "nsrr/models/all"
require "nsrr/helpers/authorization"

module Nsrr
  module Commands
    # Downloads a folder or a file from the NSRR webserver. Folders can be
    # downloaded recursively.
    class Download
      class << self
        def run(*args)
          new(*args).run
        end
      end

      attr_reader :token, :dataset_slug, :full_path, :file_comparison, :depth

      def initialize(argv)
        (@token, argv) = parse_parameter_with_value(argv, ["token"], "")
        (@file_comparison, argv) = parse_parameter(argv, ["fast", "fresh", "md5"], "md5")
        (@depth, argv) = parse_parameter(argv, ["shallow", "recursive"], "recursive")
        @dataset_slug = argv[1].to_s.split("/").first
        @full_path = (argv[1].to_s.split("/")[1..-1] || []).join("/")
      end

      # Run with Authorization
      def run
        if @dataset_slug.nil?
          puts "Please specify a dataset: " + "nsrr download DATASET".colorize(:white)
          puts "Read more on the download command here:"
          puts "  " + "https://github.com/nsrr/nsrr-gem".colorize(:blue).on_white.underline
        else
          @token = Nsrr::Helpers::Authorization.get_token(@token) if @token.to_s == ""
          @dataset = Dataset.find(@dataset_slug, @token)
          if @dataset
            @dataset.download(@full_path, depth: @depth, method: @file_comparison)
          else
            puts "\nThe dataset " + @dataset_slug.to_s.colorize(:white) + " was not found."
            (datasets, _status) = Nsrr::Helpers::JsonRequest.get("#{Nsrr::WEBSITE}/datasets.json", auth_token: @token)
            puts "Did you mean one of: #{datasets.collect { |d| d["slug"].colorize(:white)}.sort.join(", ") }" if datasets && datasets.size > 0
          end
        end
      rescue Interrupt
        puts "\nINTERRUPTED".colorize(:red)
      end

      private

      def parse_parameter(argv, options, default)
        result = default
        options.each do |option|
          result = option if argv.delete "--#{option}"
        end
        return [result, argv]
      end

      def parse_parameter_with_value(argv, options, default)
        result = default
        options.each do |option|
          argv.each do |arg|
            result = arg.gsub(/^--#{option}=/, "") if arg =~ /^--#{option}=\w/
          end
        end

        return [result, argv]
      end
    end
  end
end
