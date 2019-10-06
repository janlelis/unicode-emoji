# frozen_string_literal: true

module Unicode
  module Emoji
    VERSION = "2.2.0"
    EMOJI_VERSION = "12.0"
    CLDR_VERSION = "36"
    DATA_DIRECTORY = File.expand_path(File.dirname(__FILE__) + "/../../../data/").freeze
    INDEX_FILENAME = (DATA_DIRECTORY + "/emoji.marshal.gz").freeze

    ENABLE_NATIVE_EMOJI_UNICODE_PROPERTIES = false # As of Ruby 2.6.1, Emoji version 11 is included
  end
end

