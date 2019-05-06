# frozen_string_literal: true

require "fileutils"
require "irb"
require "io/console"

require "nsrr/helpers/constants"
require "nsrr/helpers/color"
require "nsrr/helpers/hash_helper"
require "nsrr/helpers/json_request"
require "nsrr/helpers/authorization"

require "nsrr/models/file"

module Nsrr
  module Models
    # Allows dataset and dataset file information to be retrieved, as well as
    # allowing dataset files to be downloaded.
    class Dataset
      def self.find(slug, token = nil)
        (json, _status) = Nsrr::Helpers::JsonRequest.get("#{Nsrr::WEBSITE}/api/v1/datasets/#{slug}.json", auth_token: token)
        if json
          new(json, token)
        else
          nil
        end
      end

      attr_accessor :download_token
      attr_reader :slug, :name

      def initialize(json = {}, token = nil)
        @slug = json["slug"]
        @name = json["name"]
        @files = {}
        @download_token = token
        @downloaded_folders = []
      end

      def files(path = nil)
        @files[path] ||= begin
          url = "#{Nsrr::WEBSITE}/api/v1/datasets/#{@slug}/files.json"
          params = { auth_token: @download_token, path: path }
          (json, _status) = Nsrr::Helpers::JsonRequest.get(url, params)
          (json || []).collect { |file_json| Nsrr::Models::File.new(file_json) }
        end
      end

      def folders(path = nil)
        files(path).select { |f| !f.is_file }.collect(&:file_name)
      end

      # Options include:
      # method:
      #   "md5"       => [default] Checks if a downloaded file exists with the exact md5 as the online version, if so, skips that file
      #   "fresh"     => Downloads every file without checking if it was already downloaded
      #   "fast"      => Only checks if a download file exists with the same file size as the online version, if so, skips that file
      # depth:
      #   "recursive" => [default] Downloads files in selected path folder and all subfolders
      #   "shallow"   => Only downloads files in selected path folder
      def download(full_path = nil, *args)
        options = Nsrr::Helpers::HashHelper.symbolize_keys(args.first || {})
        options[:method] ||= "md5"
        options[:depth] ||= "recursive"
        @folders_created = 0
        @files_downloaded = 0
        @downloaded_bytes = 0
        @files_skipped = 0
        @files_failed = 0

        begin
          puts "           File Check: " + options[:method].to_s.white
          puts "                Depth: " + options[:depth].to_s.white
          puts ""
          if @download_token.nil?
            @download_token = Nsrr::Helpers::Authorization.get_token(@download_token)
          end

          @start_time = Time.now

          download_helper(full_path, options)
        rescue Interrupt, IRB::Abort
          puts "\n   Interrupted".red
        end

        @downloaded_megabytes = @downloaded_bytes / (1024 * 1024)

        puts "\nFinished in #{Time.now - @start_time} seconds." if @start_time
        puts "\n#{@folders_created} folder#{"s" if @folders_created != 1} created".white + ", " +
             "#{@files_downloaded} file#{"s" if @files_downloaded != 1} downloaded".green + ", " +
             "#{@downloaded_megabytes} MiB#{"s" if @downloaded_megabytes != 1} downloaded".green + ", " +
             "#{@files_skipped} file#{"s" if @files_skipped != 1} skipped".blue + ", " +
             "#{@files_failed} file#{"s" if @files_failed != 1} failed".send(@files_failed.zero? ? :white : :red) + "\n\n"
        nil
      end

      def download_helper(full_path, options)
        return if @downloaded_folders.include?(full_path)
        @downloaded_folders << full_path

        create_folder_for_path(full_path)

        files(full_path).select(&:is_file).each do |file|
          current_folder = ::File.join(slug.to_s, file.folder.to_s)
          result = file.download(options[:method], current_folder, @download_token)
          case result
          when "fail"
            @files_failed += 1
          when "skip"
            @files_skipped += 1
          else
            @files_downloaded += 1
            @downloaded_bytes += result
          end
        end
        if options[:depth] == "recursive"
          files(full_path).reject(&:is_file).each do |file|
            download_helper(file.full_path, options)
          end
        end
      end

      def create_folder_for_path(full_path)
        files(full_path).collect(&:folder).uniq.each do |folder|
          current_folder = ::File.join(slug.to_s, folder.to_s)
          create_folder(current_folder)
        end
      end

      def create_folder(folder)
        puts "      create".white + " #{folder}"
        FileUtils.mkdir_p folder
        @folders_created += 1
      end
    end
  end
end

class Dataset < Nsrr::Models::Dataset
end
