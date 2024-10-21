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

## Usage – Regex Matching

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

There are multiple levels of Emoji detection:

### Main Regexes

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX`       | **Use this one if unsure!** Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji) and all kinds of *recommended* Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🤾🏽‍♀️` | `😴︎`, `▶`, `🏻`, `🇵🇵`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤠‍🤢`, `1`, `1⃣`
`Unicode::Emoji::REGEX_VALID` | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji) and all kinds of *valid* Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢` | `😴︎`, `▶`, `🏻`, `🇵🇵`, `1`, `1⃣`
`Unicode::Emoji::REGEX_WELL_FORMED` | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji) and all kinds of *well-formed* Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`,  `🇵🇵` | `😴︎`, `▶`, `🏻`, `1`, `1⃣`
`Unicode::Emoji::REGEX_POSSIBLE` | Matches all singleton Emoji, singleton components, all kinds of Emoji sequences, and even single digits (except for: unqualified keycap sequences) | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`,  `🇵🇵`, `😴︎`, `▶`, `🏻`, `1` | `1⃣`

#### Include Text Emoji

By default, textual Emoji (emoji characters with text variation selector or those that have a default text presentation) will not be included in the default regexes (except in `REGEX_POSSIBLE`). However, if you wish to match for them too, you can include them in your regex by appending the `_INCLUDE_TEXT` suffix:

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX_INCLUDE_TEXT`       | `REGEX` + `REGEX_TEXT` | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🤾🏽‍♀️`, `😴︎`, `▶`, `1⃣` | `🏻`, `🇵🇵`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤠‍🤢`, `1`
`Unicode::Emoji::REGEX_VALID_INCLUDE_TEXT` | `REGEX_VALID` + `REGEX_TEXT` | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`, `😴︎`, `▶`, `1⃣` | `🏻`, `🇵🇵`, `1`
`Unicode::Emoji::REGEX_WELL_FORMED_INCLUDE_TEXT` | `REGEX_WELL_FORMED` + `REGEX_TEXT` | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`,  `🇵🇵`, `😴︎`, `▶`, `1⃣` | `🏻`, `1`

#### Singleton Regexes

Matches only simple one-codepoint (+ optional variation selector) Emoji:

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX_BASIC` | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji), but no sequences at all | `😴`, `▶️` | `😴︎`, `▶`, `🏻`, `🛌🏽`, `🇵🇹`, `🇵🇵`,`2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`, `1`
`Unicode::Emoji::REGEX_TEXT`  | Matches only textual singleton Emoji (except for singleton components, like digits) | `😴︎`, `▶` | `😴`, `▶️`, `🏻`, `🛌🏽`, `🇵🇹`, `🇵🇵`,`2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`, `1`

You can see all Emoji these two regexes will match at: [character.construction/emoji-vs-text](https://character.construction/emoji-vs-text)

While `REGEX_BASIC` is part of the above regexes, `REGEX_TEXT` is only included in the `_INCLUDE_TEXT` versions.

### Comparison 

1) Fully-qualified RGI Emoji ZWJ sequence
2) Minimally-qualified RGI Emoji ZWJ sequence (lacks Emoji Presentation Selectors, but not in the first Emoji character)
3) Unqualified RGI Emoji ZWJ sequence (lacks Emoji Presentation Selector, including in the first Emoji character)
4) Non-RGI Emoji ZWJ sequence
5) Valid Region made from pair of Regional Indicators
6) Any Region made from pair of Regional Indicators
7) RGI Flag Emoji Tag Sequences (England, Scotland, Wales)
8) Valid Flag Emoji Tag Sequences (any known sub-division)
9) Any Flag Emoji Tag Sequences (any tag sequence)
10) Basic Default Emoji Presentation Characters or Text characters with Emoji Presentation Selector
11) Basic Default Text Presentation Characters or Basic Emoji with Text Presentation Selector
12) Non-Emoji (unqualified) keycap sequence

Regex | 1 RGI/FQE | 2 RGI/MQE | 3 RGI/UQE | 4 Non-RGI | 5 Valid Re­gion | 6 Any Re­gion | 7 RGI Tag | 8 Valid Tag | 9 Any Tag | 10 Basic Emoji | 11 Basic Text | 12 Text Key­cap
-|-|-|-|-|-|-|-|-|-|-|-|-
REGEX                          | ✅ | ❌ | ❌    | ❌ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌
REGEX INCLUDE TEXT             | ✅ | ❌ | ❌    | ❌ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ | ✅ | ✅
REGEX VALID                    | ✅ | ✅ | (✅)¹ | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ | ✅ | ❌ | ❌
REGEX VALID INCLUDE TEXT       | ✅ | ✅ | ✅    | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅
REGEX WELL FORMED              | ✅ | ✅ | (✅)¹ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌
REGEX WELL FORMED INCLUDE TEXT | ✅ | ✅ | ✅    | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅
REGEX POSSIBLE                 | ✅ | ✅ | ✅    | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌
REGEX BASIC                    | ❌ | ❌ | ❌    | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌
REGEX TEXT                     | ❌ | ❌ | ❌    | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅

¹ Matches all unqualified Emoji, except for textual singleton Emoji (see columns 11, 12)

See [spec files](/spec) for detailed examples about which regex matches which kind of Emoji.

### Picking the Right Emoji Regex

- Usually you just want `REGEX` (RGI set)
- If you want broader matching (any ZWJ sequences, more sub-region flags), choose `REGEX_VALID`
- If you need to match any region flag and any tag sequence, choose `REGEX_WELL_FORMED`
- Use the `_INCLUDE_TEXT` suffix with any of the above, if you want to also match basic textual Emoji
- And finally, there is also the option to use `REGEX_POSSIBLE`, which is a simplified test for possible Emoji, comparable to `REGEX_WELL_FORMED*`. It might contain false positives, however, the regex is less complex and [suggested in the Unicode standard itself](https://www.unicode.org/reports/tr51/#EBNF_and_Regex) as a first check.

### Examples

Desc | Emoji | Escaped | `REGEX` (RGI) | `REGEX_VALID` (Valid) | `REGEX_WELL_FORMED` (Well-formed) | `REGEX_POSSIBLE`
-----|-------|---------|---------------|-----------------------|-----------------------------------|-----------------
RGI ZWJ Sequence   | 🤾🏽‍♀️ | `\u{1F93E 1F3FD 200D 2640 FE0F}` | ✅ | ✅ | ✅ | ✅
Valid ZWJ Sequence | 🤠‍🤢 | `\u{1F920 200D 1F922}` | ❌  | ✅ | ✅ | ✅
Known Region       | 🇵🇹 | `\u{1F1F5 1F1F9}` | ✅ | ✅ | ✅ | ✅
Unknown Region     | 🇵🇵 | `\u{1F1F5 1F1F5}` | ❌  | ❌  | ✅ | ✅
RGI Tag Sequence   | 🏴󠁧󠁢󠁳󠁣󠁴󠁿 | `\u{1F3F4 E0067 E0062 E0073 E0063 E0074 E007F}` | ✅ | ✅ | ✅ | ✅
Valid Tag Sequence | 🏴󠁧󠁢󠁡󠁧󠁢󠁿 | `\u{1F3F4 E0067 E0062 E0061 E0067 E0062 E007F}` | ❌  | ✅ | ✅ | ✅
Well-formed Tag Sequence | 😴󠁧󠁢󠁡󠁡󠁡󠁿 | `\u{1F634 E0067 E0062 E0061 E0061 E0061 E007F}` | ❌  | ❌  | ✅ | ✅

Please see [the standard](https://www.unicode.org/reports/tr51/#Emoji_Sets) for more details, examples, explanations.

More info about valid vs. recommended Emoji can also be found in this [blog article on Emojipedia](https://blog.emojipedia.org/unicode-behind-the-curtain/).

### Extended Pictographic Regex

`Unicode::Emoji::REGEX_PICTO` matches single codepoints with the **Extended_Pictographic** property. For example, it will match `✀` BLACK SAFETY SCISSORS.

`Unicode::Emoji::REGEX_PICTO_NO_EMOJI` matches single codepoints with the **Extended_Pictographic** property, but excludes Emoji characters.

See [character.construction/picto](https://character.construction/picto) for a list of all non-Emoji pictographic characters.

### Partial Regexes

**Please note:** Might get removed or renamed in the future. This the same as `\p{Emoji}`

Matches potential Emoji parts (often, this is not what you want):

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX_ANY`   | Matches any Emoji-related codepoint (but no variation selectors, tags, or zero-width joiners). Please not that this will match Emoji-parts rather than complete Emoji, for example, single digits! | `😴`, `▶`, `🏻`, `🛌`, `🏽`, `🇵`, `🇹`, `2`, `🏴`, `🤾`, `♀`, `🤠`, `🤢` | -

## Usage – List

Use `Unicode::Emoji::LIST` or the **list** method to get a ordered and categorized list of Emoji:

```ruby
Unicode::Emoji.list.keys
# => ["Smileys & Emotion", "People & Body", "Component", "Animals & Nature", "Food & Drink", "Travel & Places", "Activities", "Objects", "Symbols", "Flags"]

Unicode::Emoji.list("Food & Drink").keys
# => ["food-fruit", "food-vegetable", "food-prepared", "food-asian", "food-marine", "food-sweet", "drink", "dishware"]

Unicode::Emoji.list("Food & Drink", "food-asian")
=> ["🍱", "🍘", "🍙", "🍚", "🍛", "🍜", "🍝", "🍠", "🍢", "🍣", "🍤", "🍥", "🥮", "🍡", "🥟", "🥠", "🥡"]
```

Please note that categories might change with future versions of the Emoji standard, although this has not happened often.

A list of all Emoji (generated from this gem) can be found at [character.construction/emoji](https://character.construction/emoji).

## Usage – Properties Data

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
