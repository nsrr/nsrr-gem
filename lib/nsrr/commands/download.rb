# frozen_string_literal: true

require "nsrr/models/all"
require "nsrr/helpers/authorization"
require "nsrr/helpers/color"

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
        (@file, argv) = parse_parameter_with_value(argv, ["file"], "")
        @dataset_slug = argv[1].to_s.split("/").first
        @full_path = (argv[1].to_s.split("/")[1..-1] || []).join("/")
      end

      # Run with Authorization
      def run
        if @dataset_slug.nil?
          puts "Please specify a dataset: " + "nsrr download DATASET".white
          puts "Read more on the download command here:"
          puts "  " + "https://github.com/nsrr/nsrr-gem".bg_gray.blue.underline
        else
          @token = Nsrr::Helpers::Authorization.get_token(@token) if @token.to_s == ""
          @dataset = Dataset.find(@dataset_slug, @token)
          if @dataset
            @dataset.download(@full_path, depth: @depth, method: @file_comparison, file: Regexp.new(@file))
          else
            puts "\nThe dataset " + @dataset_slug.white + " was not found."
            datasets = all_datasets
            return if datasets.empty?

            puts "Did you mean one of: #{datasets.collect { |d| d["slug"].white }.sort.join(", ")}"
          end
        end
      rescue Interrupt
        puts "\nINTERRUPTED".red
      end

      private

      def all_datasets
        datasets = []
        page = 1
        loop do
          new_datasets = datasets_on_page(page)
          datasets += new_datasets
          page += 1
          break unless new_datasets.size == 10
        end
        datasets
      end

      def datasets_on_page(page)
        params = { auth_token: @token, page: page }
        (datasets, _status) = Nsrr::Helpers::JsonRequest.get("#{Nsrr::WEBSITE}/api/v1/datasets.json", params)
        datasets || []
      end

      def parse_parameter(argv, options, default)
        result = default
        options.each do |option|
          result = option if argv.delete "--#{option}"
        end
        [result, argv]
      end

      def parse_parameter_with_value(argv, options, default)
        result = default
        options.each do |option|
          argv.each do |arg|
            result = arg.gsub(/^--#{option}=/, "") if arg =~ /^--#{option}=[^\s]/
          end
        end
        [result, argv]
      end
    end
  end
end
