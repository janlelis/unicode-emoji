# Unicode::Emoji [![[version]](https://badge.fury.io/rb/unicode-emoji.svg)](https://badge.fury.io/rb/unicode-emoji)  [![[ci]](https://github.com/janlelis/unicode-emoji/workflows/Test/badge.svg)](https://github.com/janlelis/unicode-emoji/actions?query=workflow%3ATest)

Provides Unicode Emoji data and regexes, incorporating the latest Unicode and Emoji standards.

Also includes a categorized list of recommended Emoji.

Emoji version: **15.0** (September 2022)

CLDR version (used for sub-region flags): **43** (April 2023)

Supported Rubies: **3.2**, **3.1**, **3.0**

No longer supported Rubies, but might still work: **2.7**, **2.6**, **2.5**, **2.4**, **2.3**

If you are stuck on an older Ruby version, checkout the latest [0.9 version](https://rubygems.org/gems/unicode-emoji/versions/0.9.3) of this gem.

## Gemfile

```ruby
gem "unicode-emoji"
```

## Usage

### Regex

The gem includes a bunch of Emoji regexes, which are compiled out of various Emoji Unicode data sources.

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

Matches (non-textual) Emoji of all kinds:

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX`       | **Use this if unsure!** Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji) and all kind of *recommended* Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🤾🏽‍♀️` | `😴︎`, `▶`, `🏻`, `🇵🇵`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤠‍🤢`
`Unicode::Emoji::REGEX_VALID` | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji) and all kind of *valid* Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢` | `😴︎`, `▶`, `🏻`, `🇵🇵`
`Unicode::Emoji::REGEX_WELL_FORMED` | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji) and all kind of *well-formed* Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`,  `🇵🇵` | `😴︎`, `▶`, `🏻`

##### Picking the Right Emoji Regex

- Usually you just want `REGEX` (RGI set)
- If you want broader matching (e.g. more sub-regions), choose `REGEX_VALID`
- If you even want to match for invalid sequences, too, use `REGEX_WELL_FORMED`

Please see [the standard](https://www.unicode.org/reports/tr51/#Emoji_Sets) for details.

Property | `REGEX` (RGI / Recommended) | `REGEX_VALID` (Valid) | `REGEX_WELL_FORMED` (Well-formed)
---------|-----------------------------|-----------------------|----------------------------------
Region "🇵🇹"                    | Yes | Yes | Yes
Region "🇵🇵"                   | No  | No  | Yes
Tag Sequence "🏴󠁧󠁢󠁳󠁣󠁴󠁿"              | Yes | Yes | Yes
Tag Sequence "🏴󠁧󠁢󠁡󠁧󠁢󠁿"              | No  | Yes | Yes
Tag Sequence "😴󠁧󠁢󠁡󠁡󠁡󠁿"              | No  | No  | Yes
ZWJ Sequence "🤾🏽‍♀️"           | Yes | Yes | Yes
ZWJ Sequence "🤠‍🤢"            | No  | Yes | Yes

More info about valid vs. recommended Emoji in this [blog article on Emojipedia](https://blog.emojipedia.org/unicode-behind-the-curtain/).

#### Singleton Regexes

Matches only simple one-codepoint (+ optional variation selector) Emoji:

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX_BASIC` | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji), but no sequences at all | `😴`, `▶️` | `😴︎`, `▶`, `🏻`, `🛌🏽`, `🇵🇹`, `🇵🇵`,`2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`
`Unicode::Emoji::REGEX_TEXT`  | Matches only textual singleton Emoji (except for singleton components, like digit 1) | `😴︎`, `▶` | `😴`, `▶️`, `🏻`, `🛌🏽`, `🇵🇹`, `🇵🇵`,`2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`

#### Include Textual Emoji

By default, textual Emoji (emoji characters with text variation selector or those that have a default text presentation) will not be included in the default regexes. However, if you wish to match for them too, you can include them in your regex by appending the `_INCLUDE_TEXT` suffix:

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

A list of all Emoji can be found at [character.construction](https://character.construction).

### Properties

Allows you to access the codepoint data form Unicode's [emoji-data.txt](https://www.unicode.org/Public/13.0.0/ucd/emoji/emoji-data.txt) file:

```ruby
require "unicode/emoji"

Unicode::Emoji.properties "☝" # => ["Emoji", "Emoji_Modifier_Base"]
```

## Also See

- [Unicode® Technical Standard #51](https://www.unicode.org/reports/tr51/proposed.html)
- [Emoji categories](https://unicode.org/emoji/charts/emoji-ordering.html)
- Ruby gem which displays [Emoji sequence names](https://github.com/janlelis/unicode-sequence_name)
- Part of [unicode-x](https://github.com/janlelis/unicode-x)

## MIT

- Copyright (C) 2017-2023 Jan Lelis <https://janlelis.com>. Released under the MIT license.
- Unicode data: https://www.unicode.org/copyright.html#Exhibit1
