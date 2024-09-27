# PKGNAME

|  |     |
|--|:---:|
| [**Documentation**][docs-latest-url]    | [<img src="https://img.shields.io/badge/docs-latest-blue.svg" alt = "doc badge" height="30">][docs-latest-url] |
| [**CI tests**][checks-url]        | [<img src="https://github.com/gbruer15/PKGNAME.jl/actions/workflows/checks.yaml/badge.svg?branch=main" alt = "CI badge" height="30">][checks-url] |
| [**Code Coverage**][codecov-url]    | [<img src="https://gbruer15.github.io/PKGNAME.jl/coverage/badge.svg" alt = "coverage badge" height="30">][codecov-url] |

[docs-latest-url]: https://gbruer15.github.io/PKGNAME.jl
[checks-url]: https://github.com/gbruer15/PKGNAME.jl/actions/workflows/checks.yaml?query=branch%3Amain
[docs-build-url]: https://github.com/gbruer15/PKGNAME.jl/actions/workflows/docs.yaml?query=branch%3Amain
[codecov-url]: https://gbruer15.github.io/PKGNAME.jl/coverage/

This package exists as a template for quickly getting a Julia package set up with continuous integration and documentation support.
If you have suggestions for making this better, you are very welcome to make an issue or pull request to discuss it.

Some information on using this repo can be found in the [wiki](https://github.com/gbruer15/PKGNAME.jl/wiki).

## Repository Structure[^1]

This repository follows a standard Julia project structure:

- `src/`: Contains the main source code for the project with the entrypoint being `src/PKGNAME.jl`.
- `test/`: Includes test files for the project with the entrypoint being `test/runtests.jl`.
- `docs/`: Houses documentation files.
- `ci_scripts/`: Contains scripts used for continuous integration.
- `Project.toml`: Defines the project's dependencies and metadata.
- `makefile`: Provides various commands for building, testing, and managing the project.
- `LICENSE`: Contains the license information for the project.
- `README.md`: You are here! Provides an overview and instructions for the project.

Additional files may be generated if you develop this package.

- `*.cov`: Stores coverage information for each file generated during testing.
- `coverage-lcov.info`: Combines `*.cov` files generated during testing.
- `coverage-lcov`: Stores coverage information as HTML generated from `coverage-lcov.info`.
- `Manifest.toml`: Locks the exact versions of dependencies used.


## Makefile[^1]

This makefile is designed to streamline common development tasks for a Julia project, including testing, documentation generation, code formatting, and managing development environments.

### Using a makefile

To use a makefile, you need to run the commands in a terminal from the directory containing the makefile. The general syntax for running a make command is:

```
make <target>
```

Where `<target>` is the name of the task you want to run. For example:

- To run tests: `make test`
- To generate documentation: `make doc`
- To format code: `make autoformat`
- To open up a development Julia REPL: `make dev-repl`

You can run these commands in your terminal as long as you have Make installed on your system and you're in the correct directory. If you're unsure which targets are available, you can typically run `make` without any arguments to see the default target, or check the makefile itself for a list of defined targets.

Remember that some targets may require additional tools or dependencies to be installed on your system, such as Julia, specific Julia packages, or coverage tools.

### Targets

#### `make help`

Displays a list of available targets with brief descriptions. This is useful for quickly seeing what commands are available in the Makefile.

#### `make test`

Runs the project's tests using Julia's package manager with coverage enabled.

#### `make autoformat`

Automatically formats Julia code in the `src`, `test`, `docs`, `ext`, and `examples` directories using JuliaFormatter.

#### `make doc`

Generates project documentation. It depends on the `docsetup` target and attempts to generate coverage HTML before building the docs.

#### `make docsetup`

Sets up the documentation environment by developing the current package and instantiating its dependencies.

#### `make coverage-lcov.info`

Processes coverage information and generates an LCOV info file.

#### `make coverage-lcov`

Generates an HTML coverage report from the LCOV info file. This uses the [lcov](https://github.com/linux-test-project/lcov) package, which is available for installation from several package managers.

#### `make clean_coverage`

Cleans up coverage-related files and folders.

#### `make dev-repl`

Starts an interactive Julia REPL with the project environment, Revise, and TestEnv activated for development purposes.


## GitHub Workflows[^1]

This repository uses GitHub Actions for continuous integration, compatibility checks, and automated tagging. The workflows are defined in [./.github/workflows](./.github/workflows). Here's a brief overview of each workflow:

### All CI

The main continuous integration workflow that runs these sub-workflows:
- Auto-format: Runs the code formatter and creates a pull request if changes are needed
- CI Tests: Runs tests on multiple Julia versions and operating systems and generates code coverage reports
- Build/Deploy Docs: Builds and deploys the documentation

Triggers: Pull requests to main and pushes to main

### CompatHelper

Automatically updates the `[compat]` entries in your `Project.toml` file:
- Checks for new versions of dependencies
- Creates pull requests to update compatibility bounds

Triggers: Monthly schedule and manual dispatch

### Untested: TagBot

Automates the creation of release tags and changelogs:
- Creates GitHub releases when new versions are registered in the Julia General Registry
- Generates changelogs based on merged pull requests and issues

Triggers: Comments on issues (for JuliaTagBot) and manual dispatch

These workflows help maintain the project by automating testing, formatting, documentation, dependency management, and release processes.


[^1]: Note: This section was generated by Claude 3.5 Sonnet from the Anthropic AI company on June 26, 2024, based on the contents of the repo at the time. It has since been reviewed and edited by a human.
