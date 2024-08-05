include("process_coverage.jl")
using Downloads: download

function process_coverage_badge(badge_filename, coverage_filename, folders...; title="coverage", kwargs...)
    coverage = process_coverage(coverage_filename, folders...; kwargs...)
    covered_lines, total_lines = get_summary(coverage)
    proportion = covered_lines / total_lines

    # Based on Nuno Cruces' work here: https://github.com/ncruces/go-coverage-report/blob/main/coverage.sh
    if proportion >= 0.9
        color = "brightgreen"
    elseif proportion >= 0.8
        color = "green"
    elseif proportion >= 0.7
        color = "yellowgreen"
    elseif proportion >= 0.6
        color = "yellow"
    elseif proportion >= 0.5
        color = "orange"
    else
        color = "red"
    end

    percentage = trunc(Int, proportion * 100)
    url = "https://img.shields.io/badge/$title-$percentage%25-$color"
    download(url, badge_filename)
    return coverage
end


if abspath(PROGRAM_FILE) == @__FILE__
    # Parse ARGS.
    badge_filename = ARGS[1]
    mark_uncovered = (ARGS[2] == "--")
    if mark_uncovered
        coverage_filename = ARGS[3]
        folders = ARGS[4:end]
    else
        coverage_filename = ARGS[2]
        folders = ARGS[3:end]
    end

    # Process coverage files.
    coverage = process_coverage_badge(badge_filename, coverage_filename, folders...; mark_uncovered)

    # Print summary.
    covered_lines, total_lines = get_summary(coverage)
    println("Covered lines: ", covered_lines)
    println("  Total lines: ", total_lines)
end
