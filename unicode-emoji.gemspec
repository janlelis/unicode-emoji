# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/unicode/emoji/constants"

Gem::Specification.new do |gem|
  gem.name          = "unicode-emoji"
  gem.version       = Unicode::Emoji::VERSION
  gem.summary       = "Retrieve Emoji data about Unicode codepoints."
  gem.description   = "[Emoji #{Unicode::Emoji::EMOJI_VERSION}] A small Ruby library which provides Unicode Emoji data and regexes, incorporating the latest Unicode and Emoji standards. Includes a categorized list of recommended Emoji."
  gem.authors       = ["Jan Lelis"]
  gem.email         = ["hi@ruby.consulting"]
  gem.homepage      = "https://github.com/janlelis/unicode-emoji"
  gem.license       = "MIT"

  gem.files         = Dir["{**/}{.*,*}"].select{ |path| File.file?(path) && path !~ /^pkg/ }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.metadata      = { "rubygems_mfa_required" => "true" }

  gem.required_ruby_version = ">= 2.3", "< 4.0"

  gem.add_dependency "unicode-version", "~> 1.0"
end
