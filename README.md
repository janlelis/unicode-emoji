# Unicode::Emoji [![[version]](https://badge.fury.io/rb/unicode-emoji.svg)](http://badge.fury.io/rb/unicode-emoji)  [![[travis]](https://travis-ci.org/janlelis/unicode-emoji.svg)](https://travis-ci.org/janlelis/unicode-emoji)

A small Ruby library which provides Unicode Emoji data and regexes.

Emoji version: **5.0**

Supported Rubies: **2.4**, **2.3**, **2.2**, **2.1**

## Gemfile

```ruby
gem "unicode-emoji"
```

## Usage

### Properties

Allows you to access the codepoint data form Unicode's [emoji-data.txt](http://unicode.org/Public/emoji/5.0/emoji-data.txt) file:

```ruby
require "unicode/emoji"

Unicode::Emoji.properties "☝" # => ["Emoji", "Emoji_Modifier_Base"]
```

### Regex

Five Emoji regexes are included, which are compiled out of various Emoji Unicode data.

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

Regex                         | Description | Example Matches | Example Non-Matches
------------------------------|-------------|-----------------|--------------------
`Unicode::Emoji::REGEX`       | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji) and all kind of valid Emoji sequences, but restrict ZWJ and TAG sequences to recommended sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🤾🏽‍♀️` | `😴︎`, `▶`, `🏻`, `🇵🇵`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤠‍🤢`
`Unicode::Emoji::REGEX_VALID` | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji) and all kind of valid Emoji sequences | `😴`, `▶️`, `🛌🏽`, `🇵🇹`, `2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢` | `😴︎`, `▶`, `🏻`, `🇵🇵`
`Unicode::Emoji::REGEX_BASIC` | Matches (non-textual) singleton Emoji (except for singleton components, like a skin tone modifier without base Emoji), but no sequences | `😴`, `▶️` | `😴︎`, `▶`, `🏻`, `🛌🏽`, `🇵🇹`, `🇵🇵`,`2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`
`Unicode::Emoji::REGEX_TEXT`  | Matches only textual singleton Emoji (except for singleton components, like digit 1) | `😴︎`, `▶` | `😴`, `▶️`, `🏻`, `🛌🏽`, `🇵🇹`, `🇵🇵`,`2️⃣`, `🏴󠁧󠁢󠁳󠁣󠁴󠁿`, `🏴󠁧󠁢󠁡󠁧󠁢󠁿`, `🤾🏽‍♀️`, `🤠‍🤢`
`Unicode::Emoji::REGEX_ANY`   | Matches any Emoji-related codepoint (but no variation selectors or tags) | `😴`, `▶`, `🏻`, `🛌`, `🏽`, `🇵`, `🇹`, `2`, `🏴`, `🤾`, `♀`, `🤠`, `🤢` | -


## Also See

- [Unicode® Technical Standard #51](http://www.unicode.org/reports/tr51/proposed.html)
- [Emoji data](http://unicode.org/Public/emoji/5.0/)
- [Emoji sequence names](https://github.com/janlelis/unicode-sequence_name)
- Part of [unicode-x](https://github.com/janlelis/unicode-x)

## MIT

- Copyright (C) 2017 Jan Lelis <http://janlelis.com>. Released under the MIT license.
- Unicode data: http://www.unicode.org/copyright.html#Exhibit1
