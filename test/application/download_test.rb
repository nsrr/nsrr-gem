require 'test_helper'
require 'test_helpers/capture'
require 'test_helpers/nsrr_website_rack'

require 'nsrr/commands/download'

module ApplicationTests
  class DownloadTest < Minitest::Test

    include TestHelpers::Capture
    include TestHelpers::NsrrWebsiteRack

    def test_new_download
      Artifice.activate_with(app) do
        output, error = util_capture do
          Nsrr.launch ['download', 'wecare', '--token=abc123']
        end

        assert_match "1 folder created", output
        assert_match "0 files downloaded", output
        assert_match "0 MiBs downloaded", output
        assert_match "0 files skipped", output
        assert_match "0 files failed", output
      end

    end

    def test_subfolder_specified
      download = Nsrr::Commands::Download.new(['download', 'wecare/subfolder', '--shallow', '--fast'])
      assert_equal 'wecare', download.dataset_slug
      assert_equal 'subfolder', download.folder
      assert_equal 'shallow', download.depth
      assert_equal 'fast', download.file_comparison
    end

    def test_multiple_subfolders_specified
      download = Nsrr::Commands::Download.new(['download', 'wecare/folder/subfolder'])
      assert_equal 'wecare', download.dataset_slug
      assert_equal 'folder/subfolder', download.folder
    end

    def test_parameter_defaults
      download = Nsrr::Commands::Download.new(['download', 'wecare'])
      assert_equal 'wecare', download.dataset_slug
      assert_equal '', download.folder
      assert_equal 'recursive', download.depth
      assert_equal 'md5', download.file_comparison
    end

    def test_unusual_parameter_order
      download = Nsrr::Commands::Download.new(['download', '--fast', '--shallow', 'wecare/subfolder'])
      assert_equal 'wecare', download.dataset_slug
      assert_equal 'subfolder', download.folder
      assert_equal 'shallow', download.depth
      assert_equal 'fast', download.file_comparison
    end

  end
end
