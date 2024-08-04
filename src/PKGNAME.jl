
"""
This module provides the [`greeting`](@ref) function for generating greetings.

# Examples

```jldoctest
julia> greeting("Grant")
"Hello Grant"

```
"""
module PKGNAME

include("pkg_stuff.jl")

using PackageExtensionCompat
function __init__()
    @require_extensions
end

end # module PKGNAME
