require 'deep_merge'

module Piggyback

  # Build up configuration from multiple sources
  #
  class Configuration
    def initialize (hash = {})
      @versions = [sanitize_keys(hash)]
    end

    # Get the current version of the configuration
    def current
      @versions.last
    end

    # - push new version
    # - sanitize keys
    # - perform a deep merge
    def merge!(hash = {})
      @versions.push current().dup.deep_merge!(sanitize_keys(hash))

      current()
    end

    # .to_sym
    # - becomes _
    # split up by ::
    #
    # NOTE:
    # a::b::c: 1     #=> { a: { b: { c: 1 } } }
    # a:       2     #=> { a: 2 } 
    #
    # The above referenced key a (of a::b::c) is overwritten in the second line!
    # Lexical order is important.
    def sanitize_keys (hash)
      hash.reduce({}) do |seed, (key, value)|
        key, value = split(key.to_s.gsub('-', '_'), value)
        
        seed[key] = value
        seed
      end
    end

    # Similar to Hiera, split keys by :: and generate subsequent hashes
    # { keys::into::hashes: value } 
    # -> { keys: { into: { hashes: value } } }
    #
    def split (key, value)
      keys = key.split('::')

      [keys.first, keys.reverse.reduce(value) { |seed, k| Hash[k, seed] }[keys.first]]
    end
  end
end
