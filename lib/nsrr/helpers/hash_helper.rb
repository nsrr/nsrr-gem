module Nsrr
  module Helpers
    class HashHelper
      def self.symbolize_keys(hash)
        hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      end
    end
  end
end
