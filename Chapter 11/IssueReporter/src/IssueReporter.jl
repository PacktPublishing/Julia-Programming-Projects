module IssueReporter

using Pkg, Pkg.TOML, GitHub, URIParser, Documenter, DocStringExtensions

function generalregistrypath() :: String
  for i in DEPOT_PATH
    if isdir(joinpath(i, "registries", "General"))
      return joinpath(i, "registries", "General")
    end
  end

  ""
end

function generalregistry() :: Vector{Dict{String,Any}}
  if ! isempty(generalregistrypath())
    TOML.parsefile(joinpath(generalregistrypath(), "Registry.toml"))["packages"] |> values |> collect
  else
     Dict{String,Any}[]
   end
end

function searchregistry(pkgname::String) :: Dict{String,Any}
  for item in generalregistry()
    item["name"] == pkgname && return item
  end

  Dict{String,Any}()
end

"""
$(SIGNATURES)

Takes the name of a registered Julia package and returns the associated repo git URL.

Examples
```jldoctest
julia> IssueReporter.packageuri("IssueReporter")
"git://github.com/essenciary/IssueReporter.jl.git"
```
"""
function packageuri(pkgname::String) :: String
  pkg = searchregistry(pkgname)
  isempty(pkg) && return ""
  get!(TOML.parsefile(joinpath(generalregistrypath(), pkg["path"], "Package.toml")), "repo", "")
end


"""
$(SIGNATURES)

Checks if the required GitHub authentication token is defined.
"""
function tokenisdefined() :: Bool
  if ! haskey(ENV, "GITHUB_ACCESS_TOKEN")
    secrets_path = joinpath(@__DIR__, "secrets.jl")
    isfile(secrets_path) && include(secrets_path)
    haskey(ENV, "GITHUB_ACCESS_TOKEN") || return false
  end

  true
end


"""
$(SIGNATURES)

Returns the configured GitHub authentication token, if defined -- or throws an error otherwise.
"""
function token() :: String
  tokenisdefined() && return ENV["GITHUB_ACCESS_TOKEN"]
  error("""ENV["GITHUB_ACCESS_TOKEN"] is not set -- please make sure it's passed as a command line argument or defined in the `secrets.jl` file.""")
end


"""
$(SIGNATURES)

Performs GitHub authentication and returns the OAuth2 object, required by further GitHub API calls.
"""
function githubauth()
  token() |> GitHub.authenticate
end


"""
$(SIGNATURES)

Converts a registered Julia package name to the corresponding GitHub "username/repo_name" string.

Examples
```jldoctest
julia> IssueReporter.repoid("IssueReporter")
"essenciary/IssueReporter.jl"
```
"""
function repoid(package_name::String)
  pkg_url = packageuri(package_name) |> URIParser.parse_url
  repo_info = endswith(pkg_url.path, ".git") ? replace(pkg_url.path, r".git$"=>"") : pkg_url.path

  repo_info[2:end]
end


"""
$(SIGNATURES)

Creates a new GitHub issue with the title `title` and the content `body` onto the repo corresponding to the registered package called `pack-age_name`.
"""
function report(package_name::String, title::String, body::String)
  # GitHub.create_issue(repoid(package_name), auth = githubauth(), params = Dict(:title => title, :body => body))
  GitHub.create_issue("essenciary/julia-by-example-test-repo", auth = github_auth(), params = Dict(:title => title, :body => body))
end

end # module
