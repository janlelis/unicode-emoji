# frozen_string_literal: true

module Unicode
  module Emoji
    VERSION = "2.6.0"
    EMOJI_VERSION = "13.1"
    CLDR_VERSION = "37"
    DATA_DIRECTORY = File.expand_path(File.dirname(__FILE__) + "/../../../data/").freeze
    INDEX_FILENAME = (DATA_DIRECTORY + "/emoji.marshal.gz").freeze
  end
end

