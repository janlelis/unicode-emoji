# frozen_string_literal: true

require_relative 'constants'

module Unicode
  module Emoji
    INDEX = Marshal.load(Gem.gunzip(File.binread(INDEX_FILENAME)))
  end
end
