# Changelog

## 0.2.1 (8 September 2014)

 * Update dependencies for Elixir 1.0 release.

## 0.2.0 (5 September 2014)

 * Initial release.
 * Does everything the Ruby version does, typically faster!
    - Most operations are at least ~50% faster in microbenchmarks.
    - Notable exception are the `.find_by_*` family of functions, which appear
      to run ~50% slower. (Slow is relative of course, in this case, it means
      ~0.4ms/op on my hardware.)
 * Should be API compatible with the most recent release of the Ruby version of
   the library.  Setting the version number accordingly.  Minor releases will be
   versioned independently, but will make an attempt to keep major version
   numbers consistent to feature set across different platforms.
