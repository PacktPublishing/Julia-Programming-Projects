module IssueReporter

using MetadataTools, URIParser, GitHub, DocStringExtensions

"""
$(SIGNATURES)

Takes the name of a METADATA Julia package and returns the associated git URL.

#Examples
```jldoctest
julia> IssueReporter.package_uri("Trie")
"git://github.com/JuliaArchive/Trie.jl.git"
````
"""
function package_uri(package_name::String)
  MetadataTools.get_pkg(package_name).url
end


"""
$(SIGNATURES)

Checks if the required GitHub authentication token is defined.
"""
function token_is_defined()
  if ! haskey(ENV, "GITHUB_ACCESS_TOKEN")
    secrets_path = joinpath(Pkg.dir("IssueReporter"), "secrets.jl")
    isfile(secrets_path) && include(secrets_path)
    haskey(ENV, "GITHUB_ACCESS_TOKEN") || return false
  end

  true
end


"""
$(SIGNATURES)

Returns the configured GitHub authentication token, if defined -- or throws an error otherwise.
"""
function token()
  token_is_defined() && return ENV["GITHUB_ACCESS_TOKEN"]
  error("""ENV["GITHUB_ACCESS_TOKEN"] is not set -- please make sure it's passed as a command line argument or defined in the `secrets.jl` file.""")
end


"""
$(SIGNATURES)

Accepts a GitHub authentication token and stores it in the `secrets.jl` configuration file.
The `secrets.jl` file is added to `.gitignore` so it won't be accidentally commited.
"""
function configure(token::String)
  open(joinpath(Pkg.dir("IssueReporter"), "secrets.jl"), "w") do io
    write(io, """ENV["GITHUB_ACCESS_TOKEN"] = "$token" """)
  end
end


"""
$(SIGNATURES)

Performs GitHub authentication and returns the OAuth2 object, required by further GitHub API calls.
"""
function github_auth()
  token() |> GitHub.authenticate
end


"""
$(SIGNATURES)

Converts a registered Julia package name to the corresponding GitHub "username/repo_name" string.

#Examples
```jldoctest
julia> IssueReporter.repo_id("Trie")
"JuliaArchive/Trie.jl"
````
"""
function repo_id(package_name::String)
  pkg_url = package_uri(package_name) |> URIParser.parse_url
  repo_info = endswith(pkg_url.path, ".git") ? replace(pkg_url.path, r".git$", "") : pkg_url.path

  repo_info[2:end]
end


"""
$(SIGNATURES)

Creates a new GitHub issue with the title `title` and the content `body` onto the repo corresponding to the registered package called `package_name`.
"""
function report(package_name::String, title::String, body::String)
  # GitHub.create_issue(repo_id(package_name), auth = github_auth(), params = Dict(:title => title, body => body)) # <-- commented out so we don't spam real repos
  GitHub.create_issue("essenciary/julia-by-example-test-repo", auth = github_auth(), params = Dict(:title => title, body => body))
end

end # module