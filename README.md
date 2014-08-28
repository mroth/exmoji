Exmoji
======
An Elixir/Erlang library providing low level operations for dealing with Emoji
glyphs in the Unicode standard. :cool:

** WORK IN PROGRESS - NOT READY TO USE YET **

** TODO: Add description **


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
