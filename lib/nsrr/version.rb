module Nsrr
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 1
    TINY = 0
    BUILD = "beta5" # nil, "pre", "rc", "rc2"

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join('.')
  end
end
