# frozen_string_literal: true

module Unicode
  module Emoji
    VERSION = "0.9.4".freeze
    EMOJI_VERSION = "5.0".freeze
    DATA_DIRECTORY = File.expand_path(File.dirname(__FILE__) + '/../../../data/').freeze
    INDEX_FILENAME = (DATA_DIRECTORY + '/emoji.marshal.gz').freeze

    ENABLE_NATIVE_EMOJI_UNICODE_PROPERTIES = false
  end
end

