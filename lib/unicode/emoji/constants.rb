# frozen_string_literal: true

module Unicode
  module Emoji
    VERSION = "3.6.0"
    EMOJI_VERSION = "16.0"
    CLDR_VERSION = "45"
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
    SPEC_TAGS                     = [*0xE0030..0xE0039, *0xE0061..0xE007A].freeze
    EMOJI_KEYCAP_SUFFIX           = 0x20E3
    ZWJ                           = 0x200D
    VS15                          = 0xFE0E
    VS16                          = 0xFE0F
    REGIONAL_INDICATORS           = [*0x1F1E6..0x1F1FF].freeze
  end
end
