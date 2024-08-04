
export greeting

"""
	greeting(name)

Construct a string for greeting the given name.

# Examples

```jldoctest
julia> greeting("Grant")
"Hello Grant"

```

```jldoctest
julia> greeting(1)
"Hello 1"

```
"""
greeting(name) = "Hello $name"
