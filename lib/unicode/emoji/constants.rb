# frozen_string_literal: true

module Unicode
  module Emoji
    VERSION = "2.5.0.unreleased"
    EMOJI_VERSION = "13.0"
    CLDR_VERSION = "36"
    DATA_DIRECTORY = File.expand_path(File.dirname(__FILE__) + "/../../../data/").freeze
    INDEX_FILENAME = (DATA_DIRECTORY + "/emoji.marshal.gz").freeze
  end
end

