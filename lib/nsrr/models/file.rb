# Models a downloadable file or folder

module Nsrr
  module Models
    class File
      attr_reader :name, :url, :is_file, :web_file_size, :web_checksum

      def initialize(json = {})
        @name = json['file_name']
        @url = json['url']
        @web_checksum = json['checksum']
        @is_file = json['is_file']
        @web_file_size = json['file_size']
      end

      # method:
      #   'md5'       => [default] Checks if a downloaded file exists with the exact md5 as the online version, if so, skips that file
      #   'fresh'     => Downloads every file without checking if it was already downloaded
      #   'fast'      => Only checks if a download file exists with the same file size as the online version, if so, skips that file
      def download(method)
        do_md5_check = (method == 'md5')
        redownload_all = (method == 'fresh')

        if do_md5_check
          if md5_matches?
            self.skip
          else
            self.force_download
          end
        else
          if redownload_all
            self.force_download
          else
            if file_size_matches?
              self.skip
            else
              self.force_download
            end
          end
        end
      end

      def force_download
        puts "    download".colorize( :green ) + " #{self.name}"
      end

      def skip
        puts "   identical".colorize( :blue ) + " #{self.name}"
      end

      # TODO Check if web_checksum matches local file checksum
      def md5_matches?
        @web_checksum == local_checksum
        rand(2) == 1
      end

      def local_checksum
        ""
      end

      def file_size_matches?
        @web_file_size == local_filesize
        rand(2) == 1
      end

      def local_filesize
        0
      end

    end
  end
end

