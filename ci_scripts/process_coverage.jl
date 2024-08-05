"""
Coverage Report Generator

This script processes coverage data for specified folders and
generates (or appends to) an LCOV report.

Usage:
    julia process_coverage.jl <output_file> <folder1> [<folder2> ...]

Arguments:
    [--]           : Optional "--". If given, mark_uncovered is to true.
    <output_file>  : Path to the output LCOV file
    <folder1> ...  : One or more folders to process for coverage data

Behavior:
1. Imports necessary coverage tools.
2. Processes each specified folder for coverage data.
3. Combines coverage data from all folders.
4. If mark_uncovered is set, files with no coverage are marked with zero
   coverage on each line. This may cause an issue when combining with
   coverage results of the file with coverage, so it is recommended to
   not set this except for visualization.
5. Writes the combined coverage data to an LCOV file.
6. Prints a summary of covered lines and total lines.

Example:
    julia process_coverage.jl coverage.info src test

Output:
    - Generates or appends to an LCOV file at the specified output path.
    - Prints a summary of coverage to the console.
"""

include("ensure_import.jl")
@ensure_using CoverageTools

function process_coverage(output_filename, folders...; mark_uncovered=false)
    # Read original file.
    if isfile(output_filename)
        coverage = LCOV.readfile(output_filename)
    else
        coverage = Vector{FileCoverage}()
    end

    # Append new coverage information.
    for f in folders
        if isfile(f)
            push!(coverage, process_file(f))
        else
            append!(coverage, process_folder(f))
        end
    end

    coverage = merge_coverage_counts(coverage)

    if mark_uncovered
        # Mark any files that weren't run as uncovered.
        for c in coverage
            if all(isnothing.(c.coverage))
                @show "Marking $c as uncovered"
                c.coverage .= 0
            end
        end
    end

    # Write to output file.
    LCOV.writefile(output_filename, coverage)
    return coverage
end

if abspath(PROGRAM_FILE) == @__FILE__
    # Parse ARGS.
    mark_uncovered = (ARGS[1] == "--")
    if mark_uncovered
        output_filename = ARGS[2]
        folders = ARGS[3:end]
    else
        output_filename = ARGS[1]
        folders = ARGS[2:end]
    end

    # Process coverage files.
    coverage = process_coverage(output_filename, folders...; mark_uncovered)

    # Print summary.
    covered_lines, total_lines = get_summary(coverage)
    println("Covered lines: ", covered_lines)
    println("  Total lines: ", total_lines)
end
