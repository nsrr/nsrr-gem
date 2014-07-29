require 'colorize'
require 'fileutils'

require 'nsrr/helpers/constants'
require 'nsrr/helpers/hash_helper'
require 'nsrr/helpers/json_request'

require 'nsrr/models/file'

module Nsrr
  module Models
    class Dataset
      def self.find(slug)
        json = Nsrr::Helpers::JsonRequest.get("#{Nsrr::WEBSITE}/datasets/#{slug}.json")
        if json
          new(json)
        else
          nil
        end
      end

      attr_reader :slug, :name

      def initialize(json = {})
        @slug = json['slug']
        @name = json['name']
        @files = {}
        @download_token = nil
      end

      def files(path = nil)
        @files[path] ||= begin
          json = Nsrr::Helpers::JsonRequest.get("#{Nsrr::WEBSITE}/datasets/#{@slug}/json_manifest/#{path}")
          (json || []).collect{|file_json| Nsrr::Models::File.new(file_json)}
        end
      end

      def folders(path = nil)
        self.files(path).select{|f| !f.is_file}.collect{|f| f.name}
      end

      # Options include:
      # method:
      #   'md5'       => [default] Checks if a downloaded file exists with the exact md5 as the online version, if so, skips that file
      #   'fresh'     => Downloads every file without checking if it was already downloaded
      #   'fast'      => Only checks if a download file exists with the same file size as the online version, if so, skips that file
      # depth:
      #   'recursive' => [default] Downloads files in selected path folder and all subfolders
      #   'shallow'   => Only downloads files in selected path folder
      def download(path = nil, *args)
        options = Nsrr::Helpers::HashHelper.symbolize_keys(args.first || {})
        options[:method] ||= 'md5'
        options[:depth] ||= 'recursive'
        @folders_created = 0
        @files_downloaded = 0
        @downloaded_bytes = 0
        @files_skipped = 0
        @files_failed = 0

        begin
          if @download_token.to_s == ''
            puts "     File Integrity Check Method: " + options[:method].to_s.colorize(:white)
            puts "                           Depth: " + options[:depth].to_s.colorize(:white)
            set_download_token()
          end

          @start_time = Time.now

          download_helper(path, options)
        rescue Interrupt, IRB::Abort
          puts "\n   Interrupted".colorize(:red)
        end

        @downloaded_megabytes = @downloaded_bytes / (1024 * 1024)

        puts "\nFinished in #{Time.now - @start_time} seconds."
        puts "\n#{@folders_created} folder#{"s" if @folders_created != 1} created".colorize(:white) + ", " +
             "#{@files_downloaded} file#{"s" if @files_downloaded != 1} downloaded".colorize(:green) + ", " +
             "#{@downloaded_megabytes} MiB#{"s" if @downloaded_megabytes != 1} downloaded".colorize(:green) + ", " +
             "#{@files_skipped} file#{"s" if @files_skipped != 1} skipped".colorize(:blue) + ", " +
             "#{@files_failed} file#{"s" if @files_failed != 1} failed".colorize(:red) + "\n\n"
        nil
      end

      def download_helper(path, options)
        current_folder = ::File.join(self.slug.to_s, path.to_s)
        create_folder(current_folder)

        self.files(path).select{|f| f.is_file}.each do |file|
          result = file.download(options[:method], current_folder, @download_token)
          case result when 'fail'
            @files_failed += 1
          when 'skip'
            @files_skipped += 1
          else
            @files_downloaded += 1
            @downloaded_bytes += result
          end
        end

        if options[:depth] == 'recursive'
          self.files(path).select{|f| !f.is_file}.each do |file|
            folder = [path, file.name].compact.join('/')
            self.download_helper(folder, options)
          end
        end
      end

      def create_folder(folder)
        puts "      create".colorize( :white ) + " #{folder}"
        FileUtils.mkdir_p folder
        @folders_created += 1
      end

      def set_download_token
        puts  "             Get your token here: " + "https://sleepdata.org/token".colorize( :blue ).on_white.underline
        print "Please enter your download token: "
        @download_token = gets.chomp
      end

    end
  end
end

class Dataset < Nsrr::Models::Dataset
end
