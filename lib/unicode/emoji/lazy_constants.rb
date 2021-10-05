# frozen_string_literal: true

module Unicode
  module Emoji
    EMOJI_CHAR                    = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:E) }.keys.freeze
    EMOJI_PRESENTATION            = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:P) }.keys.freeze
    TEXT_PRESENTATION             = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:E) && !props.include?(:P) }.keys.freeze
    EMOJI_COMPONENT               = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:C) }.keys.freeze
    EMOJI_MODIFIER_BASES          = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:B) }.keys.freeze
    EMOJI_MODIFIERS               = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:M) }.keys.freeze

    EXTENDED_PICTOGRAPHIC         = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:X) }.keys.freeze
    EXTENDED_PICTOGRAPHIC_NO_EMOJI= INDEX[:PROPERTIES].select{ |ord, props| props.include?(:X) && !props.include?(:E) }.keys.freeze
    EMOJI_KEYCAPS                 = INDEX[:KEYCAPS].freeze
    VALID_REGION_FLAGS            = INDEX[:FLAGS].freeze
    VALID_SUBDIVISIONS            = INDEX[:SD].freeze
    RECOMMENDED_SUBDIVISION_FLAGS = INDEX[:TAGS].freeze
    RECOMMENDED_ZWJ_SEQUENCES     = INDEX[:ZWJ].freeze

    LIST                          = INDEX[:LIST].freeze.each_value(&:freeze)
    LIST_REMOVED_KEYS             = [
      "Smileys & People",
    ].freeze
  end
end
