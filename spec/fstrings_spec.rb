# frozen_string_literal: true

require 'time'

RSpec.describe FStrings do
  subject { ->(string) { described_class.f(string) } }

  let(:int) { 5 }
  let(:str) { 'string' }
  let(:tm) { Time.parse('2019-03-01 14:30') }

  its_call('simple') { is_expected.to ret 'simple' }
  its_call('{{escaped}}') { is_expected.to ret '{{escaped}}' }
  its_call("this is {int}") { is_expected.to ret "this is 5" }
  its_call('this is {str}') { is_expected.to ret 'this is string' }
  its_call('this is {str%p}') { is_expected.to ret 'this is "string"' }
  its_call("this is {str}\n\nthis is {int}") { is_expected.to ret "this is string\n\nthis is 5" }

  its_call('this is {int%+i}') { is_expected.to ret 'this is +5' }
  its_call('this is {str% 16s}') { is_expected.to ret 'this is           string' }

  its_call('this is {Math.sqrt(int)}') { is_expected.to ret 'this is 2.23606797749979' }
  its_call('this is {Math.sqrt(int)%.2f}') { is_expected.to ret 'this is 2.24' }

  its_call('this is {int=}') { is_expected.to ret 'this is int=5' }
  its_call('this is {int=%+i}') { is_expected.to ret 'this is int=+5' }
  its_call('this is {Math.sqrt(int)=}') { is_expected.to ret 'this is Math.sqrt(int)=2.23606797749979' }
  its_call('this is {Math.sqrt(int)=%.2f}') { is_expected.to ret 'this is Math.sqrt(int)=2.24' }
  its_call('this is {Math.sqrt(int) = %.2f}') { is_expected.to ret 'this is Math.sqrt(int) = 2.24' }

  its_call('this is {tm %H:%M at %d.%m.%Y}') { is_expected.to ret 'this is 14:30 at 01.03.2019' }

  context 'with custom class formatter' do
    let(:klass) { Struct.new(:x, :y) }
    let(:point) { klass.new(10, 20) }

    before {
      described_class.def_formatter(klass) { |val, str|
        str.gsub('%x', val.x.to_s).gsub('%y', val.y.to_s)
      }
    }

    its_call('this is [{point%x:%y}]') { is_expected.to ret 'this is [10:20]' }
  end
end
