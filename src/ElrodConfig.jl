module ElrodConfig

using Revise, BenchmarkTools, LinearAlgebra
using Cthulhu
Cthulhu.CONFIG.asm_syntax = :intel
Cthulhu.CONFIG.enable_highlighter = true

@static if Sys.ARCH == :x86_64 && VERSION ≥ v"1.7.0-beta"
  using MKL
end

macro cn(x)
  ex = Expr(
    :macrocall,
    Symbol("@code_native"),
    nothing,
    :(debuginfo = :none),
    :(syntax = :intel),
    x
  )
  println("julia> ", ex)
  esc(ex)
end
macro cl(x)
  ex = :(@code_llvm debuginfo = :none $x)
  println("julia> @code_llvm debuginfo = :none ", x)
  ex
end
macro d(x)
  ex = :(@descend_code_warntype debuginfo = :none $x)
  println("julia> @descend_code_warntype debuginfo = :none ", ex)
  ex
end

using Crayons, OhMyREPL
enable_autocomplete_brackets(false)
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

export @cn, @cl, @d, _a

end
