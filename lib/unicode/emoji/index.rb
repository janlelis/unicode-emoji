# frozen_string_literal: true

require 'rubygems/util'
require_relative 'constants'

module Unicode
  module Emoji
    INDEX = Marshal.load(Gem::Util.gunzip(File.binread(INDEX_FILENAME)))
  end
end
