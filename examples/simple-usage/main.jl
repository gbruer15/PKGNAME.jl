# # Description
# This example shows a simple use case for PKGNAME.
# Specifically, we use the [`greeting`](@ref) function to print greetings.
#
# First, we import the necessary packages.
using PKGNAME

# Then, we run the greeting function for different names, which are numeric in this case.
names = rand(10)
for name in names
    println(greeting(name))
end

# It's even easier with the Random extension.
using Random
println(greeting())
