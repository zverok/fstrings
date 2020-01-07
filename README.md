# FStrings

FStrings is an _experimental_ gem implementing Python-alike fstrings (formatting strings) in Ruby.

The idea is, in Ruby, we have two ways to insert some variable values in strings:

1. String interpolation: `puts "Foo #{value} bar"`
2. `String#%` (or `Kernel#format`, if you want): `puts "Foo %.2f value" % value`

First is more convenient (with the variable name where it should be rendered), while the second is much more powerful, allowing to specify various formatting flags. `FStrings` tries to close this gap, with a bit of idea stealing (from the Python) and a bit of dark magic ([binding_of_caller](http://github.com/banister/binding_of_caller)).

## Showcase

In its basic form, FStrings formatting looks just like string interpolation (just using `{}` instead of `#{}`):

```ruby
require 'fstrings'
include FStrings

value = 5
puts f"Simple: {value}"
# => "Simple: 5"
```

But it also allows to specify formatting flags, after `%` sign (the regular [Kernel#format](https://ruby-doc.org/core-2.7.0/Kernel.html#method-i-format)'s syntax works):

```ruby
puts f"Formatted: {value%+i}"
# => "Formatted: +5"

float = 1.2345
puts f"Formatted: {float%.2f}"
# => "Formatted: 1.23"
```

That's mostly it! But not **all** of it :)

FStrings also support **`x=` syntax** (which Python 3.8 invented), indispensable for `puts`-debugging:

```ruby
puts f"Named: {value=%+i}"
# => "Named: value=+5"

# Any expression can be interpolated this way:
r = 12
puts f"Circle area: {Math::PI * r**2 = %.3f}"
# => "Circle area: Math::PI * r**2 = 452.389"
```

FStrings allows to define **custom formatters** for your own classes, and automatically define one for `Time` (it passes the format string to `strftime`):

```ruby
puts f"Current time is {Time.now %H:%M (%b %d)}"
# => "Current time is 15:00 (Jan 07)"
```

To define your own, just do this:

```ruby
Point = Struct.new(:x, :y)
# First argument is formatted value, second is format string
FStrings.def_formatter(Point) { |val, str| str.gsub('%x', val.x.to_s).gsub('%y', val.y.to_s) }

point = Point.new(10, 20)

puts f"See, it works: {point %x;%y}"
# => "See, it works: 10;20"
```

(The formatting strings considered everything starting from the first `%` including it.)

## Quirks and problems

The library is _new and experimental_. It is _probably_ helpful in debugging, but probably not advised for any production. The problems I can think of:

* `binding_of_caller` and `eval` are used inside. It is black and unholy magic, obviously;
* fstrings-parser is not that mature; it is tested, but can break on more complicated strings (which you hopefully won't need for debugging);
* probably, parsed strings should be cached, currently, they are not (so in a method which you call 2 mln times, could provide serious slowdown);
* considering simplistic formatting string definition, statements using `%` can't be inspected (everything after `%` would be thought to be a formatting string).

## Author & license

* [Victor Shepelev](https://zverok.github.io)
* MIT.
