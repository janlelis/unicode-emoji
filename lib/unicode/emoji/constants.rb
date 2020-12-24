# frozen_string_literal: true

module Unicode
  module Emoji
    VERSION = "2.7.1"
    EMOJI_VERSION = "13.1"
    CLDR_VERSION = "38.1"
    DATA_DIRECTORY = File.expand_path(File.dirname(__FILE__) + "/../../../data/").freeze
    INDEX_FILENAME = (DATA_DIRECTORY + "/emoji.marshal.gz").freeze
  end
end

