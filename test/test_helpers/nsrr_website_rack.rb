# frozen_string_literal: true

require "artifice"
require "uri"

module TestHelpers
  # Emulates dataset file response from NSRR webserver
  module NsrrWebsiteRack
    def app
      proc do |env|
        case "#{env["PATH_INFO"]}?#{env["QUERY_STRING"]}"
        when "#{uri.path}/api/v1/datasets/wecare.json?auth_token=", "#{uri.path}/api/v1/datasets/wecare.json?auth_token=abc123"
          [200, { "Content-Type" => "application/json" }, [dataset_json_response]]
        when "#{uri.path}/api/v1/datasets/wecare/files.json?auth_token=&path=", "#{uri.path}/api/v1/datasets/wecare/files.json?auth_token=abc123&path="
          [200, { "Content-Type" => "application/json" }, [dataset_files_json_response]]
        else
          [200, { "Content-Type" => "application/json" }, []]
        end
      end
    end

    def uri
      @uri ||= URI.parse(Nsrr::WEBSITE)
    end

    def dataset_json_response
      { name: "We Care Clinical Trial", slug: "wecare" }.to_json
    end

    def dataset_files_json_response
      [
        {
          dataset: "wecare",
          full_path: "datasets",
          folder: "",
          file_name: "datasets",
          is_file: false,
          file_size: 306,
          file_checksum_md5: nil,
          archived: false
        },
        {
          dataset: "wecare",
          full_path: "forms",
          folder: "",
          file_name: "forms",
          is_file: false,
          file_size: 170,
          file_checksum_md5: nil,
          archived: false
         }
      ].to_json
    end
  end
end
