Exmoji
======
An Elixir/Erlang library providing low level operations for dealing with Emoji
glyphs in the Unicode standard. :cool:

Exmoji is like a swiss-army knife for dealing with Emoji encoding issues. If all
you need to do is translate `:poop:` into :poop:, then there are plenty of other
libs out there that will probably do what you want.  But once you are dealing
with Emoji as a fundamental part of your application, and you start to realize
the nightmare of [doublebyte encoding][doublebyte] or [variants][variant], then
this library will be your new best friend.

** WORK IN PROGRESS - NOT READY TO USE YET **


Modules
-------

### Exmoji
The main library, with detailed search and conversion functions.

### Exmoji.EmojiChar
A struct representation of a single Emoji character glyph and all of it's
associated metadata.

This module also contains some convenience methods for acting upon these
structs.

### Exmoji.Scanner
Provides very fast searches against binary strings for the presence of UTF-8
encoded Emoji glyphs.  Whereas the Ruby and NodeJS versions of this library
accomplish this via regex, the Elixir version relies on binary pattern matching,
making it very fast (anecdotally roughly 2x as fast as NodeJS, 5x Ruby).


Terminology Note
----------------
This library uses the term "char" extensively to refer to a single emoji glyph
in string encoding.  In Elixir/Erlang char means something specific, which
may be confusing because of the charlist/bitstring division (this library uses
bitstrings).  I may rename all those API functions for this version of the lib
because of that, but for now I'm keeping it consistent with other versions...

[doublebyte]: http://www.quora.com/Why-does-using-emoji-reduce-my-SMS-character-limit-to-70
[variant]: http://en.wikipedia.org/wiki/Variant_form_(Unicode)
