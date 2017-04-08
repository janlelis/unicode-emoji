# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/unicode/emoji/constants"

Gem::Specification.new do |gem|
  gem.name          = "unicode-emoji"
  gem.version       = Unicode::Emoji::VERSION
  gem.summary       = "Retrieve Emoji data about Unicode codepoints."
  gem.description   = "[Emoji #{Unicode::Emoji::EMOJI_VERSION}] Retrieve emoji data about Unicode codepoints. Also contains a regex to match emoji."
  gem.authors       = ["Jan Lelis"]
  gem.email         = ["mail@janlelis.de"]
  gem.homepage      = "https://github.com/janlelis/unicode-emoji"
  gem.license       = "MIT"

  gem.files         = Dir["{**/}{.*,*}"].select{ |path| File.file?(path) && path !~ /^pkg/ }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = "~> 2.0"
end
