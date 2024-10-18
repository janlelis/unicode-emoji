# frozen_string_literal: true

module Unicode
  module Emoji
    LIST                          = INDEX[:LIST].freeze.each_value(&:freeze)
    LIST_REMOVED_KEYS             = [
      "Smileys & People",
    ].freeze
  end
end
