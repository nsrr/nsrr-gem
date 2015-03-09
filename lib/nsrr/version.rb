module Nsrr
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 2
    TINY = 0
    BUILD = "pre" # nil, "pre", "rc", "rc2"

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join('.')
  end
end
