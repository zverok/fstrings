# frozen_string_literal: true

module FStrings
  # @private
  module Parser
    using(Module.new do
      refine String do
        def to_proc
          method(:%).to_proc
        end
      end
    end)

    class << self
      def str2code(string)
        res = []
        scan = StringScanner.new(string)
        until scan.eos?
          res << scan_simple(scan).inspect
          res << statement2code(scan_statement(scan)) unless scan.eos?
        end
        res.join(' + ')
      end

      private

      def scan_simple(scan)
        str = scan.scan_until(/\{|$/)
        if scan.peek(1) == '{'
          str + scan.scan(/\{/) + scan_simple(scan)
        else
          str.sub(/\{$/, '')
        end
      end

      def scan_statement(scan)
        expr, char = scan.scan_until(/[}%]/).then { |str| [str[0...-1], str[-1]] }
        # fmt will include the first %-char which also signifies it
        fmt, = scan.scan_until(/\}/).then { |str| [str[0...-1], str[-1]] } if char == '%'
        if expr.match?(/\s*=\s*$/)
          prefix = expr
          expr = expr.sub(/\s*=\s*$/, '')
        end
        {expr: expr.strip, fmt: fmt&.then(&'%%%s'), prefix: prefix}
      end

      def statement2code(expr:, fmt:, prefix:)
        [
          prefix&.then(&'%p +'),
          fmt&.then { 'FStrings::Formats.apply(' },
          '(',
          expr,
          ')',
          fmt&.then(&', %p)'),
          '.to_s'
        ].compact.join
      end
    end
  end
end
