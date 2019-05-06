# frozen_string_literal: true

module Nsrr
  module Helpers
    # Converts hash with string keys into hash with keys as symbols.
    class HashHelper
      def self.symbolize_keys(hash)
        hash.inject({}) do |memo, (k, v)|
          memo[k.to_sym] = v
          memo
        end
      end
    end
  end
end
