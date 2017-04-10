# frozen_string_literal: true

module Unicode
  module Emoji
    VERSION = "0.9.1".freeze
    EMOJI_VERSION = "5.0".freeze
    DATA_DIRECTORY = File.expand_path(File.dirname(__FILE__) + '/../../../data/').freeze
    INDEX_FILENAME = (DATA_DIRECTORY + '/emoji.marshal.gz').freeze
  end
end

