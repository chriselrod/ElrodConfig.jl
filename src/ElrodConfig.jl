module ElrodConfig

using Revise, BenchmarkTools, LinearAlgebra, Cthulhu, InteractiveUtils

@static if Sys.ARCH == :x86_64 && VERSION ≥ v"1.7.0-beta"
  using MKL
end

macro cn(x)
  if Sys.ARCH === :x86_64
    println("julia> @code_native syntax=:intel debuginfo=:none ", x)
    esc(
      :(ElrodConfig.InteractiveUtils.@code_native syntax = :intel debuginfo =
        :none $x)
    )
  else
    println("julia> @code_native debuginfo=:none ", x)
    esc(:(ElrodConfig.InteractiveUtils.@code_native debuginfo = :none $x))
  end
end
macro cl(x)
  println("julia> @code_llvm debuginfo = :none ", x)
  esc(:(ElrodConfig.InteractiveUtils.@code_llvm debuginfo = :none $x))
end
macro d(x)
  println("julia> @descend_code_warntype debuginfo = :none ", x)
  esc(:(ElrodConfig.Cthulhu.@descend_code_warntype debuginfo = :none $x))
end

using Crayons, OhMyREPL
import OhMyREPL: Passes.SyntaxHighlighter

Base.text_colors[:light_black] = Base.text_colors[24]
let penumbra_darkest = SyntaxHighlighter.ColorScheme()
  SyntaxHighlighter.symbol!(penumbra_darkest, crayon"#1AC2E1")
  SyntaxHighlighter.comment!(penumbra_darkest, crayon"#636363")
  SyntaxHighlighter.string!(penumbra_darkest, crayon"#61C68A")
  SyntaxHighlighter.call!(penumbra_darkest, crayon"#97A6FF")
  SyntaxHighlighter.op!(penumbra_darkest, crayon"#F48E74")
  SyntaxHighlighter.keyword!(penumbra_darkest, crayon"#E18DCE")
  SyntaxHighlighter.function_def!(penumbra_darkest, crayon"#97A6FF")
  SyntaxHighlighter.error!(penumbra_darkest, crayon"#F48E74")
  SyntaxHighlighter.argdef!(penumbra_darkest, crayon"#1AC2E1")
  SyntaxHighlighter.macro!(penumbra_darkest, crayon"#97A6FF")
  SyntaxHighlighter.number!(penumbra_darkest, crayon"#C7AD40")
  SyntaxHighlighter.text!(penumbra_darkest, crayon"#AEAEAE")
  SyntaxHighlighter.add!("Penumbra Dark Contrast++", penumbra_darkest)
end
colorscheme!("Penumbra Dark Contrast++")

# `Main._a[] = ...` when debugging with Revise
const _a = Ref{Any}()

export @cn, @cl, @d, _a, includet, @btime, @benchmark, @belapsed

function __init__()
  Cthulhu.CONFIG.asm_syntax = :intel
  Cthulhu.CONFIG.enable_highlighter = true
  enable_autocomplete_brackets(false)
end

end
