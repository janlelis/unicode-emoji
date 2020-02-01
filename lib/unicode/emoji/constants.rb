# frozen_string_literal: true

module Unicode
  module Emoji
    VERSION = "2.4.0"
    EMOJI_VERSION = "13.0"
    CLDR_VERSION = "36"
    DATA_DIRECTORY = File.expand_path(File.dirname(__FILE__) + "/../../../data/").freeze
    INDEX_FILENAME = (DATA_DIRECTORY + "/emoji.marshal.gz").freeze

    ENABLE_NATIVE_EMOJI_UNICODE_PROPERTIES = false
    # As of Ruby 2.7.0, Emoji version 12.1 is included
  end
end

