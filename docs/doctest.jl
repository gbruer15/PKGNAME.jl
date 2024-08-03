
using Documenter: DocMeta, doctest
using PKGNAME
DocMeta.setdocmeta!(PKGNAME, :DocTestSetup, :(using PKGNAME, Test); recursive=true)
doctest(PKGNAME)
