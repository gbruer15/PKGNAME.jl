using Pkg: Pkg
using PKGNAME
using Documenter
using Random # Loads PKGNAME Random extension.

using Literate

const REPO_ROOT = joinpath(@__DIR__, "..")
const DOC_SRC = joinpath(@__DIR__, "src")
const DOC_STAGE = joinpath(@__DIR__, "stage")
const DOC_BUILD = joinpath(@__DIR__, "build")

# Move src files to staging area.
mkpath(DOC_STAGE)
for (root, dirs, files) in walkdir(DOC_SRC)
    println("Directories in $root: $dirs")
    rel_root = relpath(root, DOC_SRC)
    for dir in dirs
        stage = joinpath(DOC_STAGE, rel_root, dir)
        mkpath(stage)
    end
    println("Files in $root: $files")
    for file in files
        src = joinpath(DOC_SRC, rel_root, file)
        stage = joinpath(DOC_STAGE, rel_root, file)
        cp(src, stage)
    end
end

# Process examples and put them in staging area.
build_examples = true
build_notebooks = true
build_scripts = true
examples = ["Simple Usage" => "simple-usage"]
examples_markdown = []

function update_header(content, pth)
    links = []
    if build_notebooks
        push!(links, "[Jupyter notebook](main.ipynb)")
    end
    if build_scripts
        push!(links, "[plain script](main.jl)")
    end
    if length(links) == 0
        return content
    end
    project_link = "[Project.toml](Project.toml)"
    return """
        # # Reproducing example
        # The packages for this example are documented in the $project_link.
        # # Accessing example
        # This can also be accessed as a $(join(links, ", a", ", or a ")).
    """ * content
end

mkpath(joinpath(DOC_STAGE, "examples"))
orig_project = Base.active_project()
for (ex, pth) in examples
    in_dir = joinpath(REPO_ROOT, "examples", pth)
    in_pth = joinpath(in_dir, "main.jl")
    out_dir = joinpath(DOC_STAGE, "examples", pth)
    if build_examples
        push!(examples_markdown, ex => joinpath("examples", pth, "index.md"))
        upd(content) = update_header(content, pth)

        # Copy other files over to out_dir.
        Base.Filesystem.cptree(in_dir, out_dir)
        rm(joinpath(out_dir, "main.jl"))

        if isdir(in_dir)
            Pkg.activate(in_dir)
            Pkg.develop(; path=joinpath(@__DIR__, ".."))
            Pkg.instantiate()
        end
        try
            # Build outputs.
            Literate.markdown(in_pth, out_dir; name="index", preprocess=upd, execute=true)
            if build_notebooks
                Literate.notebook(in_pth, out_dir)
            end
            if build_scripts
                Literate.script(in_pth, out_dir)
            end
        finally
            Pkg.activate(orig_project)
        end
    end
end

# Set metadata for doctests.
DocMeta.setdocmeta!(PKGNAME, :DocTestSetup, :(using PKGNAME, Test); recursive=true)
if PKGNAME.HAS_NATIVE_EXTENSIONS
    using Random
    DocMeta.setdocmeta!(
        PKGNAME.get_extension(PKGNAME, :RandomExt),
        :DocTestSetup,
        :(using PKGNAME, Test);
        recursive=true,
    )
end
makedocs(;
    modules=[PKGNAME, PKGNAME.get_extension(PKGNAME, :RandomExt)],
    authors="Grant Bruer gbruer15@gmail.com and contributors",
    sitename="PKGNAME.jl",
    source=DOC_STAGE,
    build=DOC_BUILD,
    format=Documenter.HTML(;
        repolink="https://github.com/gbruer15/PKGNAME.jl",
        canonical="https://gbruer15.github.io/PKGNAME.jl",
        edit_link="main",
        assets=String[],
        size_threshold=2 * 2^20,
    ),
    repo="github.com/gbruer15/PKGNAME.jl",
    pages=[
        "Home" => "index.md",
        "Examples" => examples_markdown,
        "Coverage" => "coverage/index.md",
    ],
    doctest=false,
)
