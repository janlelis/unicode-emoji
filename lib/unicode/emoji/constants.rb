# frozen_string_literal: true

module Unicode
  module Emoji
    VERSION = "1.1.0".freeze
    EMOJI_VERSION = "12.0".freeze
    DATA_DIRECTORY = File.expand_path(File.dirname(__FILE__) + '/../../../data/').freeze
    INDEX_FILENAME = (DATA_DIRECTORY + '/emoji.marshal.gz').freeze

    ENABLE_NATIVE_EMOJI_UNICODE_PROPERTIES = false # As of 2.6.1, this is Emoji version 11
  end
end

