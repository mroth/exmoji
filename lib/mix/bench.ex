# NOTE: this barfs on mix test since exprof is only loaded for dev....
if Mix.env == :dev do

  defmodule BenchUtils do
    def n_times(func, n) do
      _n_times(func, n, n)
    end
    defp _n_times(_, _, 0), do: :ok
    defp _n_times(func, n, i) do
      func.()
      _n_times(func, n, i-1)
    end
  end

  defmodule Mix.Tasks.Bench do
    @s3 "first a \u0023\uFE0F\u20E3 then a 🚀"

    def run(_) do
      BenchUtils.n_times fn -> Exmoji.Scanner.scan(@s3) end, 100_000
    end
  end

  defmodule Mix.Tasks.Profile do
    import ExProf.Macro
    @s3 "first a \u0023\uFE0F\u20E3 then a 🚀"

    def do_analyze do
      profile do
        BenchUtils.n_times fn -> Exmoji.Scanner.scan(@s3) end, 1000
      end
    end

    def run(_) do
      do_analyze
    end
  end

end
