Exmoji
======
An Elixir/Erlang library providing low level operations for dealing with Emoji
glyphs in the Unicode standard. :cool:

Exmoji is like a swiss-army knife for dealing with Emoji encoding issues. If all
you need to do is translate `:poop:` into :poop:, then there are plenty of other
libs out there that will probably do what you want.  But once you are dealing
with Emoji as a fundamental part of your application, and you start to realize
the nightmare of [doublebyte encoding][doublebyte] or [variants][variant], then
this library may be your new best friend. :raised_hands:

Exmoji is written by the same author as the Ruby [emoji_data.rb][rb] gem, which
is used in production by [Emojitracker.com][emojitracker] to parse well over
100M+ emoji glyphs daily. This version was written to provide all the same
functionality while being even higher performance. :dizzy:


**WORK IN PROGRESS - NOT RELEASED JUST YET**

[![Build Status](https://travis-ci.org/mroth/exmoji.svg?branch=master)](https://travis-ci.org/mroth/exmoji)

Note: `excoveralls` is currently lying, actual test coverage is :100:.

[doublebyte]: http://www.quora.com/Why-does-using-emoji-reduce-my-SMS-character-limit-to-70
[variant]: http://www.unicode.org/L2/L2011/11438-emoji-var.pdf
[rb]: https://github.com/mroth/emoji_data.rb
[emojitracker]: http://www.emojitracker.com

Installation
------------

Add it to your deps list in your `mix.exs`. Once this package has been released
_(e.g. not yet)_, you will be able to do:

```elixir
defp deps do
  [{:exmoji, "~> 0.0.1"}]
end
```

In the meantime, or to get the development version, you can pull directly from
GitHub:

```elixir
defp deps do
  [{:exmoji, github: "mroth/exmoji"}]
end
```


Modules
-------
Full API documentation is available via standard module docs or here:
https://mroth.github.io/exmoji/


#### Exmoji
The main library, with detailed search and conversion functions.

Some examples:

```iex
iex> Exmoji.from_unified("1F680")
%Exmoji.EmojiChar{name: "ROCKET", short_name: "rocket", short_names: ["rocket"],
 text: nil, unified: "1F680", variations: []}

iex> Exmoji.find_by_short_name("MOON") |> Enum.count
13

iex> for t <- Exmoji.find_by_name("tree"), do: t.name
["EVERGREEN TREE", "DECIDUOUS TREE", "PALM TREE", "CHRISTMAS TREE",
"TANABATA TREE"]

iex> Exmoji.all_doublebyte |> Enum.count
21
```

#### Exmoji.EmojiChar
A struct representation of a single Emoji character and all of its
associated metadata.

This module also contains some convenience methods for acting upon these
structs. For example, `EmojiChar.render/1` will produce a bitstring
representation of an Emoji character suitable for transmission.  It understands
which Emoji have variant encodings and will do the right thing to make sure they
are likely to display correctly on the other end.

#### Exmoji.Scanner
Provides very fast searches against binary strings for the presence of UTF-8
encoded Emoji glyphs.  Whereas the Ruby and NodeJS versions of this library
accomplish this via regular expressions, the Elixir version relies on binary
pattern matching, making it faster.

An example:

```iex
iex> Exmoji.Scanner.scan("flying on my 🚀 to visit the 👾 people.")
[%Exmoji.EmojiChar{name: "ROCKET", short_name: "rocket",
  short_names: ["rocket"], text: nil, unified: "1F680", variations: []},
 %Exmoji.EmojiChar{name: "ALIEN MONSTER", short_name: "space_invader",
  short_names: ["space_invader"], text: nil, unified: "1F47E", variations: []}]
```


Terminology Note
----------------
This library uses the term "char" extensively to refer to a single emoji glyph
in string encoding.  In Elixir/Erlang `char` means something specific, which
may be confusing because of the charlist/bitstring division (this library uses
bitstrings).  I may rename all those API functions for this version of the lib
because of that, but for now I'm keeping it consistent with the official Unicode
names for things...


License
-----------
[The MIT License (MIT)](LICENSE)
