"This module extends PKGNAME with functionality from Random."
module RandomExt

using PKGNAME: PKGNAME
using Random

"""
    greeting()

Call [`PKGNAME.greeting`](@ref) with a random name.
"""
PKGNAME.greeting() = PKGNAME.greeting(rand(5))

end
