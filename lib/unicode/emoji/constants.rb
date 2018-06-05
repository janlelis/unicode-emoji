# frozen_string_literal: true

module Unicode
  module Emoji
    VERSION = "1.1.0".freeze
    EMOJI_VERSION = "11.0".freeze
    DATA_DIRECTORY = File.expand_path(File.dirname(__FILE__) + '/../../../data/').freeze
    INDEX_FILENAME = (DATA_DIRECTORY + '/emoji.marshal.gz').freeze

    ENABLE_NATIVE_EMOJI_UNICODE_PROPERTIES = false
  end
end

