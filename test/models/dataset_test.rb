# frozen_string_literal: true

require "test_helper"
require "test_helpers/capture"
require "test_helpers/nsrr_website_rack"

require "nsrr/models/dataset"

module ModelsTests
  # Test to assure that datasets can be loaded properly.
  class DatasetTest < Minitest::Test
    include TestHelpers::Capture
    include TestHelpers::NsrrWebsiteRack

    def test_new_dataset
      d = Dataset.new({ "slug" => "wecare", "name" => "We Care Clinical Trial" })
      assert_equal "wecare", d.slug
      assert_equal "We Care Clinical Trial", d.name
    end

    def test_folder_download
      Artifice.activate_with(app) do
        d = Nsrr::Models::Dataset.find "wecare"
        assert_equal "wecare", d.slug
        assert_equal "We Care Clinical Trial", d.name
        assert_equal %w(datasets forms), d.folders
      end
    end
  end
end
