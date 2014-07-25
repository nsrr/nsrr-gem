require 'colorize'

require 'nsrr/helpers/constants'
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
      end

      def files(path = nil) # TODO CHANGE TO nil
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
      def download(path = nil, options = {})
        method = options['method'] || 'md5'
        depth = options['depth'] || 'recursive'

        self.files(path).each do |file|
          if file.is_file
            file.download(method)
          else
            # puts "Folder Not Downloaded"
          end
        end

        if depth == 'recursive'
          self.files(path).each do |file|
            unless file.is_file
              folder = [path, file.name].compact.join('/')
              puts "      create".colorize( :white ) + " #{folder}"
              self.download(folder, options)
            end
          end
        end
      end

    end
  end
end

class Dataset < Nsrr::Models::Dataset
end
