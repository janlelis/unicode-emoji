# Unicode::Emoji [![[version]](https://badge.fury.io/rb/unicode-emoji.svg)](https://badge.fury.io/rb/unicode-emoji)  [![[ci]](https://github.com/janlelis/unicode-emoji/workflows/Test/badge.svg)](https://github.com/janlelis/unicode-emoji/actions?query=workflow%3ATest)

Provides regular expressions to find Emoji in strings, incorporating the latest Unicode and Emoji standards.

Additional features:

- A categorized list of recommended Emoji
- Retrieve Emoji properties info about specific codepoints (Emoji_Modifier, Emoji_Presentation, etc.)

Emoji version: **16.0** (September 2024)

CLDR version (used for sub-region flags): **45** (April 2024)

## Gemfile

```ruby
gem "unicode-emoji"
```

## Usage

### Regex

The gem includes multiple Emoji regexes, which are compiled out of various Emoji Unicode data sources.

```ruby
require "unicode/emoji"

string = "String which contains all kinds of emoji:

- Singleton Emoji: 😴
- Textual singleton Emoji with Emoji variation: ▶️
- Emoji with skin tone modifier: 🛌🏽
- Region flag: 🇵🇹
- Sub-Region flag: 🏴󠁧󠁢󠁳󠁣󠁴󠁿
- Keycap sequence: 2️⃣
- Sequence using ZWJ (zero width joiner): 🤾🏽‍♀️

"

string.scan(Unicode::Emoji::REGEX) # => ["😴", "▶️", "🛌🏽", "🇵🇹", "🏴󠁧󠁢󠁳󠁣󠁴󠁿", "2️⃣", "🤾🏽‍♀️"]
```

#### Main Regexes

There are multiple levels of Emoji detection:

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX`       | **Use this one if unsure!** Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji) and all kinds of *recommended* Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🤾🏽‍♀️` | `😴︎`, `▶`, `🏻`, `🇵🇵`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤠‍🤢`, `1`
`Unicode::Emoji::REGEX_VALID` | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji) and all kinds of *valid* Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢` | `😴︎`, `▶`, `🏻`, `🇵🇵`, `1`
`Unicode::Emoji::REGEX_WELL_FORMED` | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji) and all kinds of *well-formed* Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`,  `🇵🇵` | `😴︎`, `▶`, `🏻`, `1`
`Unicode::Emoji::REGEX_POSSIBLE` | Matches all singleton Emoji, singleton components, all kinds of Emoji sequences, and even single digits | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`,  `🇵🇵`, `😴︎`, `▶`, `🏻`, `1` |

##### Picking the Right Emoji Regex

- Usually you just want `REGEX` (RGI set)
- If you want broader matching (any ZJW sequences, more sub-region flags), choose `REGEX_VALID`
- Even brolader is `REGEX_WELL_FORMED`, which will also match any region flag and any tag sequence 
- And then there is `REGEX_POSSIBLE` , which is a quick check for possible Emoji, which might contain false positives, [suggested in the Unicode Standard](https://www.unicode.org/reports/tr51/#EBNF_and_Regex)

Property | Escaped | `REGEX` (RGI / Recommended) | `REGEX_VALID` (Valid) | `REGEX_WELL_FORMED` (Well-formed) | `REGEX_POSSIBLE`
---------|---------|-----------------------------|-----------------------|-----------------------------------|-----------------
Region "🇵🇹" | `\u{1F1F5 1F1F9}` | Yes | Yes | Yes | Yes
Region "🇵🇵" | `\u{1F1F5 1F1F5}` | No  | No  | Yes | Yes
Tag Sequence "🏴󠁧󠁢󠁳󠁣󠁴󠁿" | `\u{1F3F4 E0067 E0062 E0073 E0063 E0074 E007F}` | Yes | Yes | Yes | Yes
Tag Sequence "🏴󠁧󠁢󠁡󠁧󠁢󠁿" | `\u{1F3F4 E0067 E0062 E0061 E0067 E0062 E007F}` | No  | Yes | Yes | Yes
Tag Sequence "😴󠁧󠁢󠁡󠁡󠁡󠁿" | `\u{1F634 E0067 E0062 E0061 E0061 E0061 E007F}` | No  | No  | Yes | Yes
ZWJ Sequence "🤾🏽‍♀️" | `\u{1F93E 1F3FD 200D 2640 FE0F}` | Yes | Yes | Yes | Yes
ZWJ Sequence "🤠‍🤢" | `\u{1F920 200D 1F922}` | No  | Yes | Yes | Yes

Please see [the standard](https://www.unicode.org/reports/tr51/#Emoji_Sets) for more details, examples, explanations.

More info about valid vs. recommended Emoji can also be found in this [blog article on Emojipedia](https://blog.emojipedia.org/unicode-behind-the-curtain/).

#### Singleton Regexes

Matches only simple one-codepoint (+ optional variation selector) Emoji:

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX_BASIC` | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji), but no sequences at all | `😴`, `▶️` | `😴︎`, `▶`, `🏻`, `🛌🏽`, `🇵🇹`, `🇵🇵`,`2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`, `1`
`Unicode::Emoji::REGEX_TEXT`  | Matches only textual singleton Emoji (except for singleton components, like digits) | `😴︎`, `▶` | `😴`, `▶️`, `🏻`, `🛌🏽`, `🇵🇹`, `🇵🇵`,`2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`, `1`

#### Include Textual Emoji

By default, textual Emoji (emoji characters with text variation selector or those that have a default text presentation) will not be included in the default regexes (except in `REGEX_POSSIBLE`). However, if you wish to match for them too, you can include them in your regex by appending the `_INCLUDE_TEXT` suffix:

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX_INCLUDE_TEXT`       | `REGEX` + `REGEX_TEXT` | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🤾🏽‍♀️`, `😴︎`, `▶` | `🏻`, `🇵🇵`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤠‍🤢`
`Unicode::Emoji::REGEX_VALID_INCLUDE_TEXT` | `REGEX_VALID` + `REGEX_TEXT` | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`, `😴︎`, `▶` | `🏻`, `🇵🇵`
`Unicode::Emoji::REGEX_WELL_FORMED_INCLUDE_TEXT` | `REGEX_WELL_FORMED` + `REGEX_TEXT` | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`,  `🇵🇵`, `😴︎`, `▶` | `🏻`

#### Extended Pictographic Regex

`Unicode::Emoji::REGEX_PICTO` matches single codepoints with the **Extended_Pictographic** property. For example, it will match `✀` BLACK SAFETY SCISSORS.

`Unicode::Emoji::REGEX_PICTO_NO_EMOJI` matches single codepoints with the **Extended_Pictographic** property, but excludes Emoji characters.

See [character.construction/picto](https://character.construction/picto) for a list of all non-Emoji pictographic characters.

#### Partial Regexes

Matches potential Emoji parts (often, this is not what you want):

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX_ANY`   | Matches any Emoji-related codepoint (but no variation selectors, tags, or zero-width joiners). Please not that this will match Emoji-parts rather than complete Emoji, for example, single digits! | `😴`, `▶`, `🏻`, `🛌`, `🏽`, `🇵`, `🇹`, `2`, `🏴`, `🤾`, `♀`, `🤠`, `🤢` | -


### List

Use `Unicode::Emoji::LIST` or the list method to get a grouped (and ordered) list of Emoji:

```ruby
Unicode::Emoji.list.keys
# => ["Smileys & Emotion", "People & Body", "Component", "Animals & Nature", "Food & Drink", "Travel & Places", "Activities", "Objects", "Symbols", "Flags"]

Unicode::Emoji.list("Food & Drink").keys
# => ["food-fruit", "food-vegetable", "food-prepared", "food-asian", "food-marine", "food-sweet", "drink", "dishware"]

Unicode::Emoji.list("Food & Drink", "food-asian")
=> ["🍱", "🍘", "🍙", "🍚", "🍛", "🍜", "🍝", "🍠", "🍢", "🍣", "🍤", "🍥", "🥮", "🍡", "🥟", "🥠", "🥡"]
```

Please note that categories might change with future versions of the Emoji standard. This gem will issue warnings when attempting to retrieve old categories using the `#list` method.

A list of all Emoji (generated from this gem) can be found at [character.construction/emoji](https://character.construction/emoji).

### Properties

Allows you to access the codepoint data form Unicode's [emoji-data.txt](https://www.unicode.org/Public/16.0.0/ucd/emoji/emoji-data.txt) file:

```ruby
require "unicode/emoji"

Unicode::Emoji.properties "☝" # => ["Emoji", "Emoji_Modifier_Base"]
```

## Also See

- [Unicode® Technical Standard #51](https://www.unicode.org/reports/tr51/)
- [Emoji categories](https://unicode.org/emoji/charts/emoji-ordering.html)
- Ruby gem which displays [Emoji sequence names](https://github.com/janlelis/unicode-sequence_name) ([as website](https://character.construction/name))
- Part of [unicode-x](https://github.com/janlelis/unicode-x)

## MIT

- Copyright (C) 2017-2024 Jan Lelis <https://janlelis.com>. Released under the MIT license.
- Unicode data: https://www.unicode.org/copyright.html#Exhibit1
