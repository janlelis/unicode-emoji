# Unicode::Emoji [![[version]](https://badge.fury.io/rb/unicode-emoji.svg)](https://badge.fury.io/rb/unicode-emoji)  [![[ci]](https://github.com/janlelis/unicode-emoji/workflows/Test/badge.svg)](https://github.com/janlelis/unicode-emoji/actions?query=workflow%3ATest)

Provides various sophisticated regular expressions to work with Emoji in strings,
incorporating the latest Unicode / Emoji standards.

Additional features:

- A categorized list of Emoji (RGI: Recommended for General Interchange)
- Retrieve Emoji properties info about specific codepoints (Emoji_Modifier, Emoji_Presentation, etc.)

Emoji version: **18.0** (September 2026)

CLDR version (used for sub-region flags): **48** (October 2025)

## Gemfile

```ruby
gem "unicode-emoji"
```

## Usage – Regex Matching

The gem includes multiple Emoji regexes, which are compiled out of various Emoji Unicode data sources.

```ruby
require "unicode/emoji"

string = "String which contains all types of Emoji sequences:

- Basic Emoji: 😴
- Textual Emoji with Emoji variation (VS16): ▶️
- Emoji with skin tone modifier: 🛌🏽
- Region flag: 🇵🇹
- Sub-Region flag: 🏴󠁧󠁢󠁳󠁣󠁴󠁿
- Keycap sequence: 2️⃣
- Skin tone modifier: 🏻
- Sequence using ZWJ (zero width joiner): 🤾🏽‍♀️
"

string.scan(Unicode::Emoji::REGEX) # => ["😴", "▶️", "🛌🏽", "🇵🇹", "🏴󠁧󠁢󠁳󠁣󠁴󠁿", "2️⃣", "🏻", "🤾🏽‍♀️"]
```

Depending on your exact usecase, you can choose between multiple levels of Emoji detection:

### Main Regexes

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX`       | **Use this one if unsure!** Matches (non-textual) Basic Emoji and all kinds of *recommended* Emoji sequences (RGI/FQE) | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🤾🏽‍♀️`, `🏻` |  `🤾🏽‍♀`, `🏌‍♂️`, `😴︎`, `▶`, `🇵🇵`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤠‍🤢`, `1`, `1⃣`
`Unicode::Emoji::REGEX_VALID` | Matches (non-textual) Basic Emoji and all kinds of *valid* Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤾🏽‍♀` ,`🏌‍♂️`, `🤠‍🤢`, `🏻` | `😴︎`, `▶`, `🇵🇵`, `1`, `1⃣`
`Unicode::Emoji::REGEX_WELL_FORMED` | Matches (non-textual) Basic Emoji and all kinds of *well-formed* Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤾🏽‍♀`,`🏌‍♂️` , `🤠‍🤢`,  `🇵🇵`, `🏻` | `😴︎`, `▶`, `1`, `1⃣`
`Unicode::Emoji::REGEX_POSSIBLE` | Matches all singleton Emoji, all kinds of Emoji sequences, and even non-Emoji singleton components like digits. Only exception: Unqualified keycap sequences are not matched | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤾🏽‍♀`, `🏌‍♂️`, `🤠‍🤢`,  `🇵🇵`, `😴︎`, `▶`, `🏻`, `1` | `1⃣`

#### Include Text Emoji

By default, textual Emoji (emoji characters with text variation selector or those that have a default text presentation) will not be included in the default regexes (except in `REGEX_POSSIBLE`). However, if you wish to match for them too, you can include them in your regex by appending the `_INCLUDE_TEXT` suffix:

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX_INCLUDE_TEXT`       | `REGEX` + `REGEX_TEXT` | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🤾🏽‍♀️`, `😴︎`, `▶`, `1⃣` , `🏻`| `🤾🏽‍♀`, `🏌‍♂️`, `🇵🇵`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤠‍🤢`, `1`
`Unicode::Emoji::REGEX_VALID_INCLUDE_TEXT` | `REGEX_VALID` + `REGEX_TEXT` | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤾🏽‍♀`, `🏌‍♂️`, `🤠‍🤢`, `😴︎`, `▶`, `1⃣` , `🏻` | `🇵🇵`, `1`
`Unicode::Emoji::REGEX_WELL_FORMED_INCLUDE_TEXT` | `REGEX_WELL_FORMED` + `REGEX_TEXT` | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤾🏽‍♀`, `🏌‍♂️`, `🤠‍🤢`,  `🇵🇵`, `😴︎`, `▶`, `1⃣` , `🏻` | `1`

#### Minimally-qualified and Unqualified Sequences

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX_INCLUDE_MQE` | Like `REGEX`, but additionally includes Emoji with missing Emoji Presentation Variation Selectors, where the first partial Emoji has all required Variation Selectors | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🤾🏽‍♀️`, `🤾🏽‍♀`, `🏻` | `🏌‍♂️`, `😴︎`, `▶`, `🇵🇵`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤠‍🤢`, `1`, `1⃣`
`Unicode::Emoji::REGEX_INCLUDE_MQE_UQE` | Like `REGEX`, but additionally includes Emoji with missing Emoji Presentation Variation Selectors | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🤾🏽‍♀️`, `🤾🏽‍♀`, `🏌‍♂️`, `🏻` | `😴︎`, `▶`, `🇵🇵`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤠‍🤢`, `1`, `1⃣`

[List of MQE and UQE Emoji sequences](https://character.construction/unqualified-emoji)

#### Singleton Regexes

Matches only simple one-codepoint (+ optional variation selector) Emoji:

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX_BASIC` | Matches (non-textual) Basic Emoji, but no sequences at all | `😴`, `▶️`, `🏻` | `😴︎`, `▶`, `🛌🏽`, `🇵🇹`, `🇵🇵`,`2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤾🏽‍♀`, `🏌‍♂️`, `🤠‍🤢`, `1`
`Unicode::Emoji::REGEX_TEXT`  | Matches only textual singleton Emoji | `😴︎`, `▶` | `😴`, `▶️`, `🏻`, `🛌🏽`, `🇵🇹`, `🇵🇵`,`2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤾🏽‍♀`, `🏌‍♂️`, `🤠‍🤢`, `1`

Here is a list of all Emoji that can be matched using the two regexes: [character.construction/emoji-vs-text](https://character.construction/emoji-vs-text). The `REGEX_BASIC` regex also matches [visual Emoji components](https://character.construction/emoji-components) (skin tone modifiers and hair components).

While `REGEX_BASIC` is part of the above regexes, `REGEX_TEXT` is only included in the `*_INCLUDE_TEXT` or `*_UQE` variants.

### Comparison 

1) Fully-qualified RGI Emoji ZWJ sequence
2) Minimally-qualified RGI Emoji ZWJ sequence (lacks Emoji Presentation Selectors, but not in the first Emoji character)
3) Unqualified RGI Emoji ZWJ sequence (lacks Emoji Presentation Selector, including in the first Emoji character). Unqualified Emoji include all basic Emoji in Text Presentation (see column 11/12).
4) Non-RGI Emoji ZWJ sequence
5) Valid Region made from a pair of Regional Indicators
6) Any Region made from a pair of Regional Indicators
7) RGI Flag Emoji Tag Sequences (England, Scotland, Wales)
8) Valid Flag Emoji Tag Sequences (any known subdivision)
9) Any Emoji Tag Sequences (any tag sequence with any base)
10) Basic Default Emoji Presentation Characters or Text characters with Emoji Presentation Selector
11) Basic Default Text Presentation Characters or Basic Emoji with Text Presentation Selector
12) Non-Emoji (unqualified) keycap

Regex | 1 RGI/FQE | 2 RGI/MQE | 3 RGI/UQE | 4 Non-RGI | 5 Valid Re­gion | 6 Any Re­gion | 7 RGI Tag | 8 Valid Tag | 9 Any Tag | 10 Basic Emoji | 11 Basic Text | 12 Text Key­cap
-|-|-|-|-|-|-|-|-|-|-|-|-
REGEX                          | ✅ | ❌ | ❌    | ❌ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌
REGEX INCLUDE TEXT             | ✅ | ❌ | ❌    | ❌ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ | ✅ | ✅
REGEX INCLUDE MQE              | ✅ | ✅ | ❌    | ❌ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌
REGEX INCLUDE MQE UQE          | ✅ | ✅ | ✅    | ❌ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ | ✅ | ✅
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

- Usually you just want `REGEX` (recommended Emoji set, RGI)
- Use `REGEX_INCLUDE_MQE` or `REGEX_INCLUDE_MQE_UQE` if you want to catch Emoji sequences with missing Variation Selectors.
- If you want broader matching (any ZWJ sequences, more sub-region flags), choose `REGEX_VALID`
- If you need to match any region flag and any tag sequence, choose `REGEX_WELL_FORMED`
- Use the `_INCLUDE_TEXT` suffix with any of the above base regexes, if you want to also match basic textual Emoji
- And finally, there is also the option to use `REGEX_POSSIBLE`, which is a simplified test for possible Emoji, comparable to `REGEX_WELL_FORMED*`. It might contain false positives, however, the regex is less complex and [suggested in the Unicode standard itself](https://www.unicode.org/reports/tr51/#EBNF_and_Regex) as a first check.

### Examples

Desc | Emoji | Escaped | `REGEX` (RGI/FQE) | `REGEX_INCLUDE_MQE` (RGI/MQE) | `REGEX_VALID` | `REGEX_WELL_FORMED` / `REGEX_POSSIBLE`
-----|-------|---------|---------------|-----------------------|-----------------------------------|-----------------
RGI ZWJ Sequence   | 🤾🏽‍♀️ | `\u{1F93E 1F3FD 200D 2640 FE0F}` | ✅ | ✅ | ✅ | ✅
RGI ZWJ Sequence MQE | 🤾🏽‍♀ | `\u{1F93E 1F3FD 200D 2640}` | ❌ | ✅ | ✅ | ✅
Valid ZWJ Sequence, Non-RGI | 🤠‍🤢 | `\u{1F920 200D 1F922}` | ❌ | ❌  | ✅ | ✅
Known Region       | 🇵🇹 | `\u{1F1F5 1F1F9}` | ✅ | ✅ | ✅ | ✅
Unknown Region     | 🇵🇵 | `\u{1F1F5 1F1F5}` | ❌ | ❌  | ❌  | ✅
RGI Tag Sequence   | 🏴󠁧󠁢󠁳󠁣󠁴󠁿 | `\u{1F3F4 E0067 E0062 E0073 E0063 E0074 E007F}` | ✅ | ✅ | ✅ | ✅
Valid Tag Sequence | 🏴󠁧󠁢󠁡󠁧󠁢󠁿 | `\u{1F3F4 E0067 E0062 E0061 E0067 E0062 E007F}` | ❌ | ❌  | ✅ | ✅
Well-formed Tag Sequence | 😴󠁧󠁢󠁡󠁡󠁡󠁿 | `\u{1F634 E0067 E0062 E0061 E0061 E0061 E007F}` | ❌ | ❌  | ❌  | ✅

Please see [the standard](https://www.unicode.org/reports/tr51/#Emoji_Sets) for more details, examples, explanations.

More info about valid vs. recommended Emoji can also be found in this [blog article on Emojipedia](https://blog.emojipedia.org/unicode-behind-the-curtain/).

### Emoji Property Regexes

Ruby includes native regex Emoji properties, as listed in the following table. You can also opt-in to use the `*_PROP_*` regexes to get the Emoji support level of this gem (instead of Ruby's). [Which Emoji version does Ruby support?](https://idiosyncratic-ruby.com/73-unicode-version-mapping.html#ruby--emoji)

Gem Regex (`Unicode::Emoji`'s Emoji support level) | Native Regex (Ruby's Emoji support level)
---------------------------------------------------|------------------------------------------
`Unicode::Emoji::REGEX_PROP_EMOJI`         | `/\p{Emoji}/`
`Unicode::Emoji::REGEX_PROP_MODIFIER`      | `/\p{EMod}/`
`Unicode::Emoji::REGEX_PROP_MODIFIER_BASE` | `/\p{EBase}/`
`Unicode::Emoji::REGEX_PROP_COMPONENT`     | `/\p{EComp}/`
`Unicode::Emoji::REGEX_PROP_PRESENTATION`  | `/\p{EPres}/`
`Unicode::Emoji::REGEX_TEXT_PRESENTATION`  | `/[\p{Emoji}&&\P{EPres}]/`

#### Extended Pictographic Regex

`Unicode::Emoji::REGEX_PICTO` matches single codepoints with the **Extended_Pictographic** property. For example, it will match `✀` BLACK SAFETY SCISSORS.

`Unicode::Emoji::REGEX_PICTO_NO_EMOJI` matches single codepoints with the **Extended_Pictographic** property, but excludes Emoji characters.

See [character.construction/picto](https://character.construction/picto) for a list of all non-Emoji pictographic characters.

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

Allows you to access the codepoint data for a single character form Unicode's [emoji-data.txt](https://www.unicode.org/Public/18.0.0/ucd/emoji/emoji-data.txt) file:

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

- Copyright (C) 2017-2026 Jan Lelis <https://janlelis.com>. Released under the MIT license.
- Unicode data: https://www.unicode.org/copyright.html#Exhibit1


## 🌐 Web Resources & Aesthetic Symbols Index
- [SYM 1F616](https://zen-dot-characters-20.pages.dev/symbol/sym-1f616/)
- [SYM 26E9](https://classic-poetry-fonts-16.pages.dev/symbol/sym-26e9/)
- [SYM 2683](https://techno-hacker-text-43.pages.dev/symbol/sym-2683/)
- [SYM 2678](https://neon-glitch-fonts-25.pages.dev/symbol/sym-2678/)
- [DAGGER CROSS SYMBOL](https://coquette-aesthetic-symbols-71.pages.dev/symbol/dagger-cross-symbol/)
- [SYM 1D482](https://neon-gamer-symbols-64.pages.dev/symbol/sym-1d482/)
- [SYM 1D460](https://kawaii-kaomoji-hub-77.pages.dev/symbol/sym-1d460/)
- [SYM 26C1](https://baroque-curse-text-56.pages.dev/symbol/sym-26c1/)
- [KAOMOJI](https://minimal-star-symbols-54.pages.dev/vi/kaomoji/)
- [SYM 1D486](https://kawaii-kaomoji-hub-12.pages.dev/symbol/sym-1d486/)
- [SYM 2616](https://coquette-aesthetic-symbols-96.pages.dev/symbol/sym-2616/)
- [SYM 1D480](https://mecha-hacker-kaomoji-26.pages.dev/symbol/sym-1d480/)
- [SYM 26E8](https://zen-aesthetic-fonts-87.pages.dev/symbol/sym-26e8/)
- [SYM 26EC](https://gothic-bio-fonts-61.pages.dev/symbol/sym-26ec/)
- [SYM 2732](https://arcane-symbol-vault-32.pages.dev/symbol/sym-2732/)
- [DISCORD STATUS](https://sleek-type-aesthetic-51.pages.dev/ru/discord-status/)
- [SYM 1F911](https://vintage-lace-symbols-54.pages.dev/symbol/sym-1f911/)
- [GOTHIC OBSIDIAN SKULL CREST](https://pastel-manga-symbols-57.pages.dev/symbol/gothic-obsidian-skull-crest/)
- [BORDERS DIVIDERS](https://neon-glitch-symbols-29.pages.dev/vi/borders-dividers/)
- [SYM 26C6](https://gothic-bio-fonts-98.pages.dev/symbol/sym-26c6/)
- [SYM 26A6](https://clean-line-emojis-77.pages.dev/symbol/sym-26a6/)
- [BORDERS DIVIDERS](https://cyber-clan-tags-38.pages.dev/ja/borders-dividers/)
- [SYM 1D441](https://clean-line-emojis-77.pages.dev/symbol/sym-1d441/)
- [SYM 2681](https://coquette-aesthetic-symbols-63.pages.dev/symbol/sym-2681/)
- [SYM 1D448](https://cyber-clan-tags-20.pages.dev/symbol/sym-1d448/)
- [SYM 274A](https://dolly-angel-fonts-14.pages.dev/symbol/sym-274a/)
- [SYM 26DA](https://chibi-emoticon-world-87.pages.dev/symbol/sym-26da/)
- [SYM 1D40C](https://clean-line-emojis-93.pages.dev/symbol/sym-1d40c/)
- [FLORAL BRANCH BOUQUET](https://clean-line-emojis-77.pages.dev/symbol/floral-branch-bouquet/)
- [GAMING WEAPONS](https://neon-glitch-fonts-25.pages.dev/pt/gaming-weapons/)
- [BRACKETS](https://clean-line-emojis-77.pages.dev/ru/brackets/)
- [SYM 1D408](https://neon-glitch-symbols-29.pages.dev/symbol/sym-1d408/)
- [SYM 1F925](https://mecha-hacker-kaomoji-26.pages.dev/symbol/sym-1f925/)
- [WARM HUG EMBRACE KAOMOJI](https://balletcore-unicode-67.pages.dev/symbol/warm-hug-embrace-kaomoji/)
- [SYM 26E3](https://pastel-kaomoji-vault-54.pages.dev/symbol/sym-26e3/)
- [SYM 1F634](https://poetic-scroll-fonts-91.pages.dev/symbol/sym-1f634/)
- [SYM 26FB](https://clean-aesthetic-arrows-99.pages.dev/symbol/sym-26fb/)
- [SYM 267F](https://chibi-emoticon-lab-65.pages.dev/symbol/sym-267f/)
- [SYM 1F47F](https://clean-aesthetic-arrows-99.pages.dev/symbol/sym-1f47f/)
- [SYM 260F](https://scholarly-script-hub-43.pages.dev/symbol/sym-260f/)
- [SYM 1D40F](https://arcane-symbol-vault-32.pages.dev/symbol/sym-1d40f/)
- [SYM 1F60B](https://clean-aesthetic-arrows-99.pages.dev/symbol/sym-1f60b/)
- [SYM 2747](https://scholarly-runes-text-68.pages.dev/symbol/sym-2747/)
- [SYM 265D](https://soft-pastel-unicode-78.pages.dev/symbol/sym-265d/)
- [SYM 1F49B](https://matrix-glitch-text-84.pages.dev/symbol/sym-1f49b/)
- [SYM 2749](https://pastel-moe-kaomoji-91.pages.dev/symbol/sym-2749/)
- [SYM 1D433](https://techwear-bio-symbols-45.pages.dev/symbol/sym-1d433/)
- [SYM 1F609](https://chibi-bunny-symbols-82.pages.dev/symbol/sym-1f609/)
- [PISCES ZODIAC FISHES](https://zen-unicode-text-24.pages.dev/symbol/pisces-zodiac-fishes/)
- [SYM 1D412](https://coquette-heart-text-40.pages.dev/symbol/sym-1d412/)
- [DISCORD STATUS](https://anime-sparkle-text-45.pages.dev/vi/discord-status/)
- [SYM 2617](https://anime-sparkle-text-56.pages.dev/symbol/sym-2617/)
- [ANTICLOCKWISE OPEN CIRCLE ARROW](https://clean-aesthetic-arrows-99.pages.dev/symbol/anticlockwise-open-circle-arrow/)
- [SYM 267D](https://baroque-font-vault-96.pages.dev/symbol/sym-267d/)
- [ROBLOX NAMES](https://clean-line-emojis-77.pages.dev/es/roblox-names/)
- [MUSIC SHARP SIGN](https://matrix-glitch-text-84.pages.dev/symbol/music-sharp-sign/)
- [SYM 1F978](https://clean-line-emojis-77.pages.dev/symbol/sym-1f978/)
- [SYM 1F629](https://sleek-arrow-symbols-42.pages.dev/symbol/sym-1f629/)
- [SYM 1F479](https://zen-aesthetic-fonts-87.pages.dev/symbol/sym-1f479/)
- [SYM 1D438](https://ribbon-bow-unicode-18.pages.dev/symbol/sym-1d438/)
- [BRACKETS](https://monochrome-bio-text-12.pages.dev/pt/brackets/)
- [SYM 1F64A](https://soft-pink-fonts-41.pages.dev/symbol/sym-1f64a/)
- [SYM 1FAE2](https://manga-emotion-symbols-69.pages.dev/symbol/sym-1fae2/)
- [SYM 1D49E](https://kawaii-kaomoji-hub-51.pages.dev/symbol/sym-1d49e/)
- [SYM 1F619](https://clean-aesthetic-arrows-99.pages.dev/symbol/sym-1f619/)
- [SYM 267E](https://glitch-matrix-fonts-28.pages.dev/symbol/sym-267e/)
- [SYM 26B1](https://sleek-border-symbols-37.pages.dev/symbol/sym-26b1/)
- [SYM 1D48F](https://mecha-gamer-fonts-53.pages.dev/symbol/sym-1d48f/)
- [SYM 1F618](https://aesthetic-spacing-fonts-10.pages.dev/symbol/sym-1f618/)
- [SYM 267F](https://angelic-bio-symbols-90.pages.dev/symbol/sym-267f/)
- [SYM 26C9](https://clean-spacing-fonts-98.pages.dev/symbol/sym-26c9/)
- [KAOMOJI](https://clean-line-emojis-77.pages.dev/es/kaomoji/)
- [SYM 1F603](https://matrix-glitch-text-84.pages.dev/symbol/sym-1f603/)
- [SYM 1D455](https://vintage-runes-text-63.pages.dev/symbol/sym-1d455/)
- [SYM 26BA](https://vintage-script-symbols-65.pages.dev/symbol/sym-26ba/)
- [SYM 1D488](https://glitch-font-studio-46.pages.dev/symbol/sym-1d488/)
- [SYM 1D481](https://minimal-star-symbols-31.pages.dev/symbol/sym-1d481/)
- [SLEEK BORDER SYMBOLS 37.PAGES.DEV](https://sleek-border-symbols-37.pages.dev/)
- [LATIN CROSS FAITH](https://gothic-bio-fonts-98.pages.dev/symbol/latin-cross-faith/)
- [SYM 26D6](https://vintage-runes-text-63.pages.dev/symbol/sym-26d6/)
- [SYM 1D420](https://clean-line-emojis-77.pages.dev/symbol/sym-1d420/)
- [TRENDING](https://clean-line-emojis-77.pages.dev/pt/trending/)
- [SYM 1F622](https://coquette-aesthetic-symbols-62.pages.dev/symbol/sym-1f622/)
- [SKULL AND CROSSBONES](https://synthwave-text-art-35.pages.dev/symbol/skull-and-crossbones/)
- [MUSIC FLAT SIGN](https://clean-aesthetic-arrows-99.pages.dev/symbol/music-flat-sign/)
- [SYM 2617](https://vintage-runes-text-63.pages.dev/symbol/sym-2617/)
- [SYM 1D427](https://mecha-text-vault-91.pages.dev/symbol/sym-1d427/)
- [FREEFIRE NAMES](https://pastel-princess-fonts-68.pages.dev/ja/freefire-names/)
- [SYM 1D41C](https://anime-sparkle-text-73.pages.dev/symbol/sym-1d41c/)
- [TABLE FLIP RAGE KAOMOJI](https://anime-sparkle-text-56.pages.dev/symbol/table-flip-rage-kaomoji/)
- [HEARTS](https://mecha-hacker-kaomoji-26.pages.dev/hearts/)
- [SYM 1FAE5](https://neon-glitch-fonts-25.pages.dev/symbol/sym-1fae5/)
- [SYM 1D427](https://angelic-bio-symbols-59.pages.dev/symbol/sym-1d427/)
- [SYM 26A3](https://poetic-scroll-fonts-91.pages.dev/symbol/sym-26a3/)
- [SYM 2684](https://anime-sparkle-text-56.pages.dev/symbol/sym-2684/)
- [STARRY ELEVATION AURA](https://minimal-star-symbols-31.pages.dev/symbol/starry-elevation-aura/)
- [SYM 1D431](https://gothic-bio-fonts-69.pages.dev/symbol/sym-1d431/)
- [TRENDING](https://clean-line-emojis-77.pages.dev/es/trending/)
- [SYM 1F60E](https://poetic-scroll-fonts-91.pages.dev/symbol/sym-1f60e/)
- [SYM 26C4](https://mecha-hacker-kaomoji-26.pages.dev/symbol/sym-26c4/)
- [SYM 26EB](https://anime-sparkle-text-58.pages.dev/symbol/sym-26eb/)
- [SYM 2675](https://gothic-bio-fonts-55.pages.dev/symbol/sym-2675/)
- [SKULL AND CROSSBONES](https://soft-pastel-unicode-78.pages.dev/symbol/skull-and-crossbones/)
- [TABLE FLIP RAGE KAOMOJI](https://poetic-scroll-fonts-91.pages.dev/symbol/table-flip-rage-kaomoji/)
- [SYM 1D426](https://anime-sparkle-text-14.pages.dev/symbol/sym-1d426/)
- [DISCORD STATUS](https://minimal-star-symbols-31.pages.dev/discord-status/)
- [LATIN CROSS HEAVY](https://neon-hacker-text-25.pages.dev/symbol/latin-cross-heavy/)
- [TIKTOK CAPTIONS](https://pastel-kaomoji-vault-54.pages.dev/ja/tiktok-captions/)
- [SYM 1FA77](https://clean-line-emojis-77.pages.dev/symbol/sym-1fa77/)
- [SYM 1D425](https://zen-unicode-symbols-89.pages.dev/symbol/sym-1d425/)
- [PT](https://cyber-clan-tags-90.pages.dev/pt/)
- [SYM 1F92C](https://cyber-clan-tags-68.pages.dev/symbol/sym-1f92c/)
- [TENDER GENTLE TEAR KAOMOJI](https://coquette-aesthetic-symbols-63.pages.dev/symbol/tender-gentle-tear-kaomoji/)
- [SYM 2680](https://neon-glitch-fonts-20.pages.dev/symbol/sym-2680/)
- [SYM 2632](https://vintage-library-text-15.pages.dev/symbol/sym-2632/)
- [FREEFIRE NAMES](https://mecha-crosshair-symbols-40.pages.dev/ja/freefire-names/)
- [ARCANE SYMBOL VAULT 32.PAGES.DEV](https://arcane-symbol-vault-32.pages.dev/)
- [PT](https://vintage-script-symbols-65.pages.dev/pt/)
- [SYM 1D40A](https://poetic-scroll-fonts-91.pages.dev/symbol/sym-1d40a/)
- [SYM 1F927](https://alchemy-occult-symbols-55.pages.dev/symbol/sym-1f927/)
- [HEARTS](https://clean-line-emojis-77.pages.dev/hearts/)
- [SYM 2638](https://cute-face-emoticons-66.pages.dev/symbol/sym-2638/)
- [SYM 2639 FE0F](https://neon-hacker-text-25.pages.dev/symbol/sym-2639-fe0f/)
- [SYM 26A7](https://clean-spacing-fonts-98.pages.dev/symbol/sym-26a7/)
- [FREEFIRE NAMES](https://anime-sparkle-text-73.pages.dev/pt/freefire-names/)
- [RU](https://pastel-princess-fonts-68.pages.dev/ru/)
- [KAOMOJI](https://alchemy-occult-symbols-55.pages.dev/ja/kaomoji/)
- [SYM 1F620](https://clean-line-emojis-77.pages.dev/symbol/sym-1f620/)
- [SYM 1F602](https://baroque-curse-text-56.pages.dev/symbol/sym-1f602/)
- [NATURE FLOWERS](https://sleek-typography-hub-12.pages.dev/ja/nature-flowers/)
