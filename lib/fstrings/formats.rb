# frozen_string_literal: true

module FStrings
  # @private
  module Formats
    class << self
      def formats
        @formats ||= {}
      end

      def []=(klass, formatter)
        formats[klass] = formatter
      end

      def for(klass)
        formats.select { |k,| klass <= k }.min_by { |k,| klass.ancestors.index(k) }.last
      end

      def apply(val, format)
        self.for(val.class).call(val, format)
      end
    end
  end
end
