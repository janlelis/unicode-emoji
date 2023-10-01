# frozen_string_literal: true

module Unicode
  module Emoji
    VERSION = "3.4.0"
    EMOJI_VERSION = "15.1"
    CLDR_VERSION = "43"
    DATA_DIRECTORY = File.expand_path('../../../data', __dir__).freeze
    INDEX_FILENAME = (DATA_DIRECTORY + "/emoji.marshal.gz").freeze

    PROPERTY_NAMES = {
      E: "Emoji",
      B: "Emoji_Modifier_Base",
      M: "Emoji_Modifier",
      C: "Emoji_Component",
      P: "Emoji_Presentation",
      X: "Extended_Pictographic",
    }.freeze

    EMOJI_VARIATION_SELECTOR      = 0xFE0F
    TEXT_VARIATION_SELECTOR       = 0xFE0E
    EMOJI_TAG_BASE_FLAG           = 0x1F3F4
    CANCEL_TAG                    = 0xE007F
    TAGS                          = [*0xE0020..0xE007E].freeze
    EMOJI_KEYCAP_SUFFIX           = 0x20E3
    ZWJ                           = 0x200D
    REGIONAL_INDICATORS           = [*0x1F1E6..0x1F1FF].freeze
  end
end
