
export greeting

"""
	greeting(name)

Construct a string for greeting the given name.

# Examples

Specify both the members and the state keys.

```jldoctest
julia> greeting("Grant")
"Hello Grant"

```
"""
greeting(name) = "Hello $name"
