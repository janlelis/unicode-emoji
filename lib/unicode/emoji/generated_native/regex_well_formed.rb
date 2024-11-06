# This file was generated by a script, please do not edit it by hand.
# See `$ rake generate_constants` and data/generate_constants.rb for more info.

module Unicode
  module Emoji
    REGEX_WELL_FORMED = /(?:(?:(?:(?:\p{EBase}\p{EMod}|(?:[\p{Emoji}&&\P{EPres}]️|\p{EPres}(?!︎)️?)|\p{Emoji})‍)+(?:\p{EBase}\p{EMod}|(?:[\p{Emoji}&&\P{EPres}]️|\p{EPres}(?!︎)️?)|\p{Emoji}))|(?:(?:(?!\p{EComp})(?:[\p{Emoji}&&\P{EPres}]️|\p{EPres}(?!︎)️?)|\p{EBase}\p{EMod})[󠀰-󠀹󠁡-󠁺]{1,30}󠁿)|\p{RI}{2}|(?:[\#\*0-9]️⃣|\p{EBase}\p{EMod}|(?!\p{EComp})(?:[\p{Emoji}&&\P{EPres}]️|\p{EPres}(?!︎)️?)))/
  end
end
