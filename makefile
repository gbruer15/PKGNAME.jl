.PHONY: help

help:
	@echo "Available targets:"
	@echo "  test           Run project tests with coverage"
	@echo "  doc            Generate project documentation"
	@echo "  docview        Launch a local server to show the documentation"
	@echo "  doctest        Run doctests for the documentation"
	@echo "  docsetup       Set up the documentation environment"
	@echo "  clean_coverage Clean up coverage-related files"
	@echo "  coverage-lcov  Generate HTML coverage report"
	@echo "  autoformat     Format Julia code in src, test, and docs directories"
	@echo "  dev-repl       Start an interactive Julia REPL for development"
	@echo "  help           Display this help message"
	@echo
	@echo "Run 'make <target>' where <target> is one of the above."
	@echo
	@echo "See README for more details."

.PHONY: test

test:
	julia --project=. -e "import Pkg; Pkg.test(coverage=true)"

.PHONY: autoformat

autoformat:
	julia -e 'include("ci_scripts/ensure_import.jl"); @ensure_import JuliaFormatter; JuliaFormatter.format(["src", "test", "docs", "examples"])'

.PHONY: doc doctest docview docsetup

doc: docsetup
	rm -rf docs/stage docs/build
	-touch src/dummy.cov -d "19730101" && $(DOC_PREFIX) $(MAKE) coverage-lcov \
	&& mkdir -p docs/stage/coverage && cp -r coverage-lcov docs/stage/coverage/site
	rm -f src/dummy.cov
	$(DOC_PREFIX) julia --project=docs docs/make.jl

doctest:
	julia --project=docs docs/doctest.jl

docview:
	julia -e 'include("ci_scripts/ensure_import.jl"); @ensure_import LiveServer; LiveServer.serve(dir="docs/build")'

docsetup: docs/Manifest.toml

docs/Manifest.toml: docs/Project.toml Project.toml
	julia --project=docs -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'

coverage-lcov.info: */*.cov
	julia ci_scripts/process_coverage.jl "$@" ./src ./test ./docs ./examples

coverage-lcov: coverage-lcov.info
	rm -rf $@
	mkdir -p $@
	genhtml -o $@ $<

.PHONY: clean_coverage

clean_coverage:
	rm -f coverage-lcov.info
	julia -e 'include("ci_scripts/ensure_import.jl"); @ensure_import CoverageTools; CoverageTools.clean_folder(".")'

.PHONY: dev-repl

dev-repl:
	julia --project=. -i -e "using Revise, TestEnv; TestEnv.activate()"
