# Models a downloadable file or folder
require 'digest/md5'

require 'nsrr/helpers/constants'
require 'nsrr/helpers/download_request'

module Nsrr
  module Models
    class File
      attr_reader :name, :is_file, :web_file_size, :web_checksum

      def initialize(json = {})
        @name = json['file_name']
        @web_checksum = json['checksum']
        @is_file = json['is_file']
        @web_file_size = json['file_size']
        @dataset_slug = json['dataset']
        @file_path = json['file_path']
      end

      # method:
      #   'md5'       => [default] Checks if a downloaded file exists with the exact md5 as the online version, if so, skips that file
      #   'fresh'     => Downloads every file without checking if it was already downloaded
      #   'fast'      => Only checks if a download file exists with the same file size as the online version, if so, skips that file
      def download(method, path, token)
        do_md5_check = (method == 'md5')
        redownload_all = (method == 'fresh')

        if do_md5_check
          if md5_matches?(path)
            skip
          else
            force_download(path, token)
          end
        else
          if redownload_all
            force_download(path, token)
          else
            if file_size_matches?(path)
              skip
            else
              force_download(path, token)
            end
          end
        end
      end

      def force_download(path, token)
        download_folder = ::File.join(Dir.pwd, path.to_s, @name.to_s)
        download_url = "#{Nsrr::WEBSITE}/datasets/#{@dataset_slug}/files/a/#{token}/m/nsrr-gem-v#{Nsrr::VERSION::STRING.gsub('.', '-')}/#{@file_path.to_s}"
        download_request = Nsrr::Helpers::DownloadRequest.new(download_url, download_folder)
        download_request.get

        if download_request.error.to_s == ''
          puts "    download".colorize(:green) + " #{@name}"
          download_request.file_size
        else
          puts "      failed".colorize(:red) + " #{@name}"
          puts "             #{download_request.error}"
          'fail'
        end
      end

      def skip
        puts "   identical".colorize(:light_blue) + " #{self.name}"
        'skip'
      end

      def md5_matches?(path)
        @web_checksum == local_checksum(path)
      end

      def local_checksum(path)
        download_folder = ::File.join(Dir.pwd, path.to_s, self.name.to_s)
        if ::File.exist?(download_folder)
          Digest::MD5.file(download_folder).hexdigest
        else
          ""
        end
      end

      def file_size_matches?(path)
        @web_file_size == local_filesize(path)
      end

      def local_filesize(path)
        download_folder = ::File.join(Dir.pwd, path.to_s, self.name.to_s)
        if ::File.exist?(download_folder)
          ::File.size(download_folder)
        else
          -1
        end
      end

    end
  end
end

