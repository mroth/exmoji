defmodule ScannerBench do
  use Benchfella

  @s0 "I liek to eat cake oh so very much cake eating is nice!! #cake #food"
  @s1 "🚀"
  @s2 "flying on my 🚀 to visit the 👾 people."
  @s3 "first a \u0023\uFE0F\u20E3 then a 🚀"

  bench "scan(s0)", do: Exmoji.Scanner.scan(@s0)
  bench "scan(s1)", do: Exmoji.Scanner.scan(@s1)
  bench "scan(s2)", do: Exmoji.Scanner.scan(@s2)
  bench "scan(s3)", do: Exmoji.Scanner.scan(@s3)

  bench "rscan(s0)", do: Exmoji.Scanner.rscan(@s0)
  bench "rscan(s1)", do: Exmoji.Scanner.rscan(@s1)
  bench "rscan(s2)", do: Exmoji.Scanner.rscan(@s2)
  bench "rscan(s3)", do: Exmoji.Scanner.rscan(@s3)
  bench "bscan(s0)", do: Exmoji.Scanner.bscan(@s0)
  bench "bscan(s1)", do: Exmoji.Scanner.bscan(@s1)
  bench "bscan(s2)", do: Exmoji.Scanner.bscan(@s2)
  bench "bscan(s3)", do: Exmoji.Scanner.bscan(@s3)

end
