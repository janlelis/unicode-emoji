# frozen_string_literal: true

require_relative "emoji/constants"
require_relative "emoji/index"

module Unicode
  module Emoji
    PROPERTY_NAMES = {
      E: "Emoji",
      B: "Emoji_Modifier_Base",
      M: "Emoji_Modifier",
      C: "Emoji_Component",
      P: "Emoji_Presentation",
      X: "Extended_Pictographic",
    }

    EMOJI_VARIATION_SELECTOR      = 0xFE0F
    TEXT_VARIATION_SELECTOR       = 0xFE0E
    EMOJI_TAG_BASE_FLAG           = 0x1F3F4
    CANCEL_TAG                    = 0xE007F
    EMOJI_KEYCAP_SUFFIX           = 0x20E3
    ZWJ                           = 0x200D

    EMOJI_CHAR                    = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:E) }.keys.freeze
    EMOJI_PRESENTATION            = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:P) }.keys.freeze
    TEXT_PRESENTATION             = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:E) && !props.include?(:P) }.keys.freeze
    EMOJI_COMPONENT               = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:C) }.keys.freeze
    EMOJI_MODIFIER_BASES          = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:B) }.keys.freeze
    EMOJI_MODIFIERS               = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:M) }.keys.freeze
    # Not needed right now:
    # EXTENDED_PICTOGRAPHIC         = INDEX[:PROPERTIES].select{ |ord, props| props.include?(:X) }.keys.freeze
    EMOJI_KEYCAPS                 = INDEX[:KEYCAPS].freeze
    VALID_REGION_FLAGS            = INDEX[:FLAGS].freeze
    VALID_SUBDIVISIONS            = INDEX[:SD].freeze
    RECOMMENDED_SUBDIVISION_FLAGS = INDEX[:TAGS].freeze
    RECOMMENDED_ZWJ_SEQUENCES     = INDEX[:ZWJ].freeze

    LIST                          = INDEX[:LIST].freeze.each_value(&:freeze)
    LIST_REMOVED_KEYS             = [
      "Smileys & People",
      "Component",
    ]

    pack = ->(ord){ Regexp.escape(Array(ord).pack("U*")) }
    join = -> (*strings){ "(?:" + strings.join("|") + ")" }
    pack_and_join = ->(ords){  join[*ords.map{ |ord| pack[ord] }] }

    if ENABLE_NATIVE_EMOJI_UNICODE_PROPERTIES
      emoji_character     = "\\p{Emoji}"
      emoji_modifier      = "\\p{Emoji Modifier}"
      emoji_modifier_base = "\\p{Emoji Modifier Base}"
      emoji_component     = "\\p{Emoji Component}"
      emoji_presentation  = "\\p{Emoji Presentation}"
    else
      emoji_character     = pack_and_join[EMOJI_CHAR]
      emoji_modifier      = pack_and_join[EMOJI_MODIFIERS]
      emoji_modifier_base = pack_and_join[EMOJI_MODIFIER_BASES]
      emoji_component     = pack_and_join[EMOJI_COMPONENT]
      emoji_presentation  = pack_and_join[EMOJI_PRESENTATION]
    end

    emoji_presentation_sequence = \
      join[
        pack_and_join[TEXT_PRESENTATION] + pack[EMOJI_VARIATION_SELECTOR],
        emoji_presentation + "(?!" + pack[TEXT_VARIATION_SELECTOR] + ")" + pack[EMOJI_VARIATION_SELECTOR] + "?",
      ]

    text_presentation_sequence = \
      join[
        pack_and_join[TEXT_PRESENTATION]+ "(?!" + join[emoji_modifier, pack[EMOJI_VARIATION_SELECTOR]] + ")" + pack[TEXT_VARIATION_SELECTOR] + "?",
        emoji_presentation + pack[TEXT_VARIATION_SELECTOR]
      ]

    emoji_modifier_sequence = \
      emoji_modifier_base + emoji_modifier

    emoji_keycap_sequence = \
      pack_and_join[EMOJI_KEYCAPS] + pack[[EMOJI_VARIATION_SELECTOR, EMOJI_KEYCAP_SUFFIX]]

    emoji_valid_region_sequence = \
      pack_and_join[VALID_REGION_FLAGS]

    emoji_valid_tag_sequence = \
      "(?:" +
        pack[EMOJI_TAG_BASE_FLAG] +
        "(?:" + VALID_SUBDIVISIONS.map{ |sd| Regexp.escape(sd.tr("\u{20}-\u{7E}", "\u{E0020}-\u{E007E}"))}.join("|") + ")" +
        pack[CANCEL_TAG] +
      ")"

    emoji_zwj_element = \
      join[
        emoji_modifier_sequence,
        emoji_presentation_sequence,
        emoji_character,
      ]

    # Matches basic singleton emoji and all kind of sequences, but restrict zwj and tag sequences to known sequences
    REGEX = Regexp.compile(
      pack_and_join[RECOMMENDED_ZWJ_SEQUENCES] +
      ?| + pack_and_join[RECOMMENDED_SUBDIVISION_FLAGS] +
      ?| + emoji_modifier_sequence +
      ?| + "(?!" + emoji_component + ")" + emoji_presentation_sequence +
      ?| + emoji_keycap_sequence +
      ?| + emoji_valid_region_sequence  +
      ""
    )

    # Matches basic singleton emoji and all kind of valid sequences
    REGEX_VALID = Regexp.compile(
      # EMOJI_TAGS.map{ |base, spec| "(?:" + pack[base] + "[" + pack[spec] + "]+" + pack[CANCEL_TAG] + ")" }.join("|") +
      emoji_valid_tag_sequence +
      ?| + "(?:" + "(?:" + emoji_zwj_element + pack[ZWJ] + "){1,3}" + emoji_zwj_element + ")" +
      ?| + emoji_modifier_sequence +
      ?| + "(?!" + emoji_component + ")" + emoji_presentation_sequence +
      ?| + emoji_keycap_sequence +
      ?| + emoji_valid_region_sequence +
      ""
    )

    # Matches only basic single, non-textual emoji
    # Ignores "components" like modifiers or simple digits
    REGEX_BASIC = Regexp.compile(
      "(?!" + emoji_component + ")" + emoji_presentation_sequence
    )

    # Matches only basic single, textual emoji
    # Ignores "components" like modifiers or simple digits
    REGEX_TEXT = Regexp.compile(
      "(?!" + emoji_component + ")" + text_presentation_sequence
    )

    # Matches any emoji-related codepoint
    REGEX_ANY = Regexp.compile(
      emoji_character
    )

    def self.properties(char)
      ord = get_codepoint_value(char)
      props = INDEX[:PROPERTIES][ord]

      if props
        props.map{ |prop| PROPERTY_NAMES[prop] }
      else
        # nothing
      end
    end

    def self.list(key = nil, sub_key = nil)
      return LIST unless key || sub_key
      if LIST_REMOVED_KEYS.include?(key)
        $stderr.puts "Warning(unicode-emoji): The category of #{key} does not exist anymore"
      end
      LIST.dig(*[key, sub_key].compact)
    end

    def self.get_codepoint_value(char)
      ord = nil

      if char.valid_encoding?
        ord = char.ord
      elsif char.encoding.name == "UTF-8"
        begin
          ord = char.unpack("U*")[0]
        rescue ArgumentError
        end
      end

      if ord
        ord
      else
        raise(ArgumentError, "Unicode::Emoji must be given a valid string")
      end
    end

    class << self
      private :get_codepoint_value
    end
  end
end
