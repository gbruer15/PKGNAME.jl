
"""
This module provides the [`greeting`](@ref) function for generating greetings.
"""
module PKGNAME

include("pkg_stuff.jl")

using PackageExtensionCompat
function __init__()
    @require_extensions
end

end # module PKGNAME
