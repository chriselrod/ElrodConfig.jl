using ElrodConfig
using Documenter

DocMeta.setdocmeta!(ElrodConfig, :DocTestSetup, :(using ElrodConfig); recursive=true)

makedocs(;
    modules=[ElrodConfig],
    authors="Chris Elrod <elrodc@gmail.com> and contributors",
    repo="https://github.com/chriselrod/ElrodConfig.jl/blob/{commit}{path}#{line}",
    sitename="ElrodConfig.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://chriselrod.github.io/ElrodConfig.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/chriselrod/ElrodConfig.jl",
    devbranch="main",
)
