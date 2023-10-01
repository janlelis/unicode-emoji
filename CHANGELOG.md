# CHANGELOG

### 3.4.0

- Emoji 15.1

### 3.3.2

- Update valid subdivisions to CLDR 43 (no changes)

### 3.3.1

- Update valid subdivisions to CLDR 42 (no changes)

### 3.3.0

- Emoji 15.0

### 3.2.0

- Update valid subdivisions to CLDR 41

### 3.1.1

- Fix `REGEX` to be able to match complete family emoji, instead of
  sub-matching partial families, thanks @matt17r

### 3.1.0

- Update valid subdivisions to CLDR 40

### 3.0.0

- Vastly improve memory usage, patch by @radarek
  - Emoji regexes are now pre-generated and bundled with the release
  - Regexes use character classes instead of unions when possible
  - Most constants (e.g. regexes) now get autoloaded
  - See https://github.com/janlelis/unicode-emoji/pull/9 for more details

### 2.9.0

- Emoji 14.0

### 2.8.0

- Update valid subdivisions to CLDR 39

### 2.7.1

- Update valid subdivisions to CLDR 38.1

### 2.7.0

- Update valid subdivisions to CLDR 38
- Loosen Ruby dependency to allow Ruby 3.0

### 2.6.0

- Emoji 13.1

### 2.5.0

- Use native Emoji regex properties when current Ruby's Emoji support is the same as our current Emoji version
- Update valid subdivisions to CLDR 37

### 2.4.0

- Emoji 13.0

### 2.3.1

- Fix index to actually include Emoji 12.1

### 2.3.0

- Emoji 12.1

### 2.2.0

- Update subdivisions to CLDR 36

### 2.1.0

- Add `REGEX_PICTO` which matches codepoints with the **Extended_Pictographic** property
- Add `REGEX_PICTO_NO_EMOJI` which matches codepoints with the **Extended_Pictographic** property, but no **Emoji** property

### 2.0.0

- Emoji 12.0 data (including valid subdivisions)
- Introduce new `REGEX_WELL_FORMED` to be able to match for invalid tag and region sequences
- Introduce new `*_INCLUDE_TEXT` regexes which include matching for textual presentation emoji
- Refactoring: Update Emoji matching to latest standard while keeping naming close to standard
- Issue warning when using `#list` method to retrieve outdated category
- Change matching for ZWJ sequences: Do not limit sequence to a maximum of 3 ZWJs

### 1.1.0

- Emoji 11.0
- Do not depend on rubygems (only use zlib stdlib for unzipping)

### 1.0.3

- Explicitly load rubygems/util, fixes regression in 1.2.1

### 1.0.2

- Use `Gem::Util` for `gunzip`, removes deprecation warning

### 1.0.1

- Actually set required Ruby version to 2.3 in gemspec

### 1.0.0

- Drop support for Ruby below 2.3, use 0.9 if you need to
- Internal refactorings, no API change

### 0.9.3

- Implement native Emoji regex matchers, but do not activate or document, yet

### 0.9.2

- REGEX_TEXT: Do not match if the text emoji is followed by a emoji modifier

### 0.9.1

- Include a categorized list of recommended Emoji

### 0.9.0

- Initial release (Emoji version 5.0)
