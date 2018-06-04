## CHANGELOG

### Next

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

