require 'artifice'
require 'uri'

module TestHelpers
  module NsrrWebsiteRack
    def app
      proc do |env|
        uri = URI.parse(Nsrr::WEBSITE)
        case env["PATH_INFO"] when "#{uri.path}/datasets/wecare.json", "#{uri.path}/a/abc123/datasets/wecare.json"
          [200, { 'Content-Type' => 'application/json' }, [ { name: 'We Care Clinical Trial', slug: 'wecare' }.to_json ]]
        when "#{uri.path}/datasets/wecare/json_manifest/", "#{uri.path}/datasets/wecare/a/abc123/json_manifest/"
          [200, { 'Content-Type' => 'application/json' },
            [ [{ file_name: "datasets", checksum: nil, is_file: false, file_size: 306, dataset: "wecare", file_path: "datasets"},
               { file_name: "forms", checksum: nil, is_file: false, file_size: 170, dataset: "wecare", file_path: "forms"}
              ].to_json ]
          ]
        else
          [200, { 'Content-Type' => 'application/json' }, [  ]]
        end
      end
    end
  end
end
