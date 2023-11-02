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
  esc(
    :(ElrodConfig.Cthulhu.@descend_code_typed debuginfo = :none annotate_source =
      false iswarn = true $x)
  )
end

using Crayons, OhMyREPL
import OhMyREPL: Passes.SyntaxHighlighter

function set_colors()
  # Base.text_colors[:light_black] = Base.text_colors[24]
  let catppuccin_mocha = SyntaxHighlighter.ColorScheme()
    SyntaxHighlighter.symbol!(catppuccin_mocha, crayon"#1AC2E1")
    SyntaxHighlighter.comment!(catppuccin_mocha, crayon"#6C7086")
    SyntaxHighlighter.string!(catppuccin_mocha, crayon"#A6E3A1")
    SyntaxHighlighter.call!(catppuccin_mocha, crayon"#89B4FA")
    SyntaxHighlighter.op!(catppuccin_mocha, crayon"#89DCEB")
    SyntaxHighlighter.keyword!(catppuccin_mocha, crayon"#CBA6F7")
    SyntaxHighlighter.function_def!(catppuccin_mocha, crayon"#F38BA8")
    SyntaxHighlighter.error!(catppuccin_mocha, crayon"#11111B")
    SyntaxHighlighter.argdef!(catppuccin_mocha, crayon"#CDD6F4")
    SyntaxHighlighter.macro!(catppuccin_mocha, crayon"#F9E2AF")
    SyntaxHighlighter.number!(catppuccin_mocha, crayon"#FAB387")
    SyntaxHighlighter.text!(catppuccin_mocha, crayon"#AEAEAE")
    SyntaxHighlighter.add!("Catppuccin Mocha", catppuccin_mocha)
  end
  colorscheme!("Catppuccin Mocha")
end

# `Main._a[] = ...` when debugging with Revise
const _a = Ref{Any}()

export @cn,
  @cl,
  @d,
  _a,
  includet,
  @btime,
  @benchmark,
  @belapsed,
  @descend,
  @descend_code_typed,
  @descend_code_warntype

function __init__()
  Cthulhu.CONFIG.asm_syntax = :intel
  Cthulhu.CONFIG.enable_highlighter = true
  enable_autocomplete_brackets(false)
  BenchmarkTools.DEFAULT_PARAMETERS.seconds = 1
  ccall(:jl_generating_output, Cint, ()) == 1 && return nothing
  # let's not brush problems under a rug
  @eval BenchmarkTools.gcscrub() = nothing
  set_colors()
end

end
