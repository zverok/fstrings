# frozen_string_literal: true

require 'binding_of_caller'
require 'strscan'

require_relative 'fstrings/formats'
require_relative 'fstrings/parser'

# Python-alike fstrings (formatting strings) with a Ruby flavour.
#
# @example
#   include FStrings
#
#   i = 1
#   f = 1.23
#
#   # Basic form: Just like #{}
#   f"Simple! {i}"
#   # => "Simple! 1"
#
#   # Inline formatting is supported, same flags as Kernel#format
#   f"Look: {i%+i}"
#   # => "Look: +1"
#   f"Floats... {f%.1f}"
#   # => "Floats... 1.2"
#
#   # Any statement is supported:
#   f"The whole statement: {i + f %.1f}"
#   # => "The whole statement: 2.2"
#
#   # = at the end of statement handy for debugging:
#   f"Variable names, too! {i + f = %.1f}"
#   # => "Variable names, too! i + f = 2.2"
#
#   # Time and date formatting is supported:
#   f"Currently, it is {Time.now %H:%M (at %b %d)}"
#   # => "Currently, it is 14:31 (at Jan 07)"
#
#   # Custom object formatting definition is supported:
#   Point = Struct.new(:x, :y)
#   FStrings.def_formatter(Point) { |val, fmtstring| fmtstring % [val.x, val.y] }
#   f"The point: [{p= %.1f;%.1f}]"
#   # => "The point: [p= 1.3;2.5]"
#
module FStrings
  # Main library's interface. See {FStrings} main docs for examples.
  # @param string [String] Formatting string
  # @return String
  def f(string)
    # TODO: cache str2code results?
    binding.of_caller(1).eval(Parser.str2code(string))
  end

  extend self

  # Define custom formatters for user classes. Formatting block should accept `value` of
  # specified class, and formatting `string`, and return string.
  #
  # See main {FStrings} docs for a (simplistic) example of usage.
  #
  # @param klass [Module] Type of values the formatter is defined for.
  # @yield value Of the specified `klass`
  # @yield fmtstring [String] What was after `%` sign in the fstring (including `%` itself)
  # @yieldreturn String
  #
  def self.def_formatter(klass, &formatter)
    Formats[klass] = formatter
  end

  def_formatter(Object) { |val, string| string % val }
  def_formatter(Time, &:strftime)
  require 'date'
  def_formatter(Date, &:strftime)
  def_formatter(DateTime, &:strftime)
end
