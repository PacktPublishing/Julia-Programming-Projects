using Pkg
pkg"activate .."
push!(LOAD_PATH,"../src/")
using Documenter, IssueReporter

makedocs(sitename = "IssueReporter Documentation")
