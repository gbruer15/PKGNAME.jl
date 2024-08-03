using Pkg: Pkg
using PKGNAME
using Test
using TestReports
using Aqua
using Documenter

ts = @testset ReportingTestSet "" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(PKGNAME; ambiguities=false)
        Aqua.test_ambiguities(PKGNAME)
    end

    DocMeta.setdocmeta!(PKGNAME, :DocTestSetup, :(using PKGNAME, Test); recursive=true)
    doctest(PKGNAME; manual=false)

    examples_dir = joinpath(@__DIR__, "..", "examples")
    for example in readdir(examples_dir)
        example_path = joinpath(examples_dir, example)
        @show example_path
        orig_project = Base.active_project()
        @testset "Example: $(example)" begin
            if isdir(example_path)
                Pkg.activate(example_path)
                Pkg.develop(; path=joinpath(@__DIR__, ".."))
                Pkg.instantiate()
            end
            try
                include(joinpath(example_path, "main.jl"))
            finally
                Pkg.activate(orig_project)
            end
        end
    end
end

outputfilename = joinpath(@__DIR__, "..", "report.xml")
open(outputfilename, "w") do fh
    print(fh, report(ts))
end
exit(any_problems(ts))
