# ElrodConfig

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://chriselrod.github.io/ElrodConfig.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://chriselrod.github.io/ElrodConfig.jl/dev/)
[![Build Status](https://github.com/chriselrod/ElrodConfig.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/chriselrod/ElrodConfig.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/chriselrod/ElrodConfig.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/chriselrod/ElrodConfig.jl)

My `~/.julia/config/startup.jl` is simply
```julia
using ElrodConfig, LinearAlgebra
# don't allow packages to prevent defining global variables named `pop` or `data`
# by shadowing exports
pop = data = nothing
```
