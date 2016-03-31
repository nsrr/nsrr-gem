# frozen_string_literal: true

require 'digest/md5'
require 'nsrr/helpers/constants'
require 'nsrr/helpers/download_request'

module Nsrr
  module Models
    # Models a downloadable file or folder
    class File
      attr_reader :dataset_slug, :full_path, :folder, :file_name, :is_file, :file_size, :file_checksum_md5, :archived

      def initialize(json = {})
        @dataset_slug = json['dataset']
        @full_path = json['full_path']
        @folder = json['folder']
        @file_name = json['file_name']
        @is_file = json['is_file']
        @file_size = json['file_size']
        @file_checksum_md5 = json['file_checksum_md5']
        @archived = json['archived']
        @latest_checksum = ''
        @latest_file_size = -1
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
            force_download(path, token, method)
          end
        else
          if redownload_all
            force_download(path, token, method)
          else
            if file_size_matches?(path)
              skip
            else
              force_download(path, token, method)
            end
          end
        end
      end

      # MD5 or file size checks are now performed after a file is downloaded without error.
      # If the file check fails, the file is downloaded a second time and rechecked.
      # If the second download and check fail, the file is marked as failed, and the downloader continues to the subsequent file.
      def force_download(path, token, method)
        download_folder = ::File.join(Dir.pwd, path.to_s, @file_name.to_s)
        auth_section = (token.to_s == '' ? '' : "/a/#{token}")
        download_url = "#{Nsrr::WEBSITE}/datasets/#{@dataset_slug}/files#{auth_section}/m/nsrr-gem-v#{Nsrr::VERSION::STRING.gsub('.', '-')}/#{@full_path.to_s}"
        download_request = Nsrr::Helpers::DownloadRequest.new(download_url, download_folder)
        download_request.get
        download_success = false
        if download_request.error.to_s == ''
          # Check to see if the file downloaded correctly
          # If the file size doesn't match, attempt one additional download
          download_success = did_download_succeed?(method, path)
          unless download_success
            download_request = Nsrr::Helpers::DownloadRequest.new(download_url, download_folder)
            download_request.get
            download_success = did_download_succeed?(method, path)
          end
        end
        if download_request.error.to_s == '' and download_success
          puts "  downloaded".colorize(:green) + " #{@file_name}"
          download_request.file_size
        elsif download_request.error.to_s == ''
          puts "      failed".colorize(:red) + " #{@file_name}"
          if method == 'fast'
            puts "             File size mismatch, expected: #{@file_size}"
            puts "                                   actual: #{@latest_file_size}"
          else
            puts "             File checksum mismatch, expected: #{@file_checksum_md5}"
            puts "                                       actual: #{@latest_checksum}"
          end
          ::File.delete(download_folder) if ::File.exist?(download_folder)
          'fail'
        else
          puts '      failed'.colorize(:red) + " #{@file_name}"
          puts "             #{download_request.error}"
          'fail'
        end
      end

      def skip
        puts '   identical'.colorize(:light_blue) + " #{file_name}"
        'skip'
      end

      def md5_matches?(path)
        @file_checksum_md5 == local_checksum(path)
      end

      def local_checksum(path)
        download_folder = ::File.join(Dir.pwd, path.to_s, file_name.to_s)
        @latest_checksum = if ::File.exist?(download_folder)
                             Digest::MD5.file(download_folder).hexdigest
                           else
                             ''
                           end
        @latest_checksum
      end

      def file_size_matches?(path)
        @file_size == local_filesize(path)
      end

      def local_filesize(path)
        download_folder = ::File.join(Dir.pwd, path.to_s, file_name.to_s)
        @latest_file_size = if ::File.exist?(download_folder)
                              ::File.size(download_folder)
                            else
                              -1
                            end
        @latest_file_size
      end

      def did_download_succeed?(method, path)
        if method == 'fast'
          file_size_matches?(path)
        else
          md5_matches?(path)
        end
      end
    end
  end
end
