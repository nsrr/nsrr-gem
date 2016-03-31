# frozen_string_literal: true

require 'test_helper'
require 'test_helpers/capture'

require 'nsrr/models/file'

module ModelsTests
  class FileTest < Minitest::Test
    include TestHelpers::Capture

    def test_new_file
      f = Nsrr::Models::File.new({
        'dataset' => 'wecare',
        'full_path' => 'folder/test.txt',
        'folder' => 'folder/',
        'file_name' => 'test.txt',
        'is_file' => true,
        'file_size' => 9,
        'file_checksum_md5' => 'abc',
        'archived' => false,
      })

      assert_equal 'wecare',          f.dataset_slug
      assert_equal 'folder/test.txt', f.full_path
      assert_equal 'folder/',         f.folder
      assert_equal 'test.txt',        f.file_name
      assert_equal true,              f.is_file
      assert_equal 9,                 f.file_size
      assert_equal 'abc',             f.file_checksum_md5
      assert_equal false,             f.archived
    end
  end
end
