# IssueReporter

[![Build Status](https://travis-ci.org/essenciary/IssueReporter.jl.svg?branch=master)](https://travis-ci.org/essenciary/IssueReporter.jl)

[![Coverage Status](https://coveralls.io/repos/essenciary/IssueReporter.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/essenciary/IssueReporter.jl?branch=master)

[![codecov.io](http://codecov.io/github/essenciary/IssueReporter.jl/coverage.svg?branch=master)](http://codecov.io/github/essenciary/IssueReporter.jl?branch=master)


<a id='IssueReporter.jl-Documentation-1'></a>

# IssueReporter.jl Documentation

`IssueReporter.jl` is a Julia package which makes it easy to report a new issue with a METADATA registered package.
In order to use it, it needs to be configured with a valid GitHub authentication token. Follow the instructions from
https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/ to generate a new token -- make sure
that it has the `repo` access.

Once you have the token, run `IssueReporter.configure(your_access_token_here)` to configure the package.
The token is stored in a file called `secrets.jl` which is added to `.gitignore`.

You can now open issues by calling:
`IssueReporter.report("Julia package name", "issue title", "issue body")


- [IssueReporter.jl Documentation](index.md#IssueReporter.jl-Documentation-1)
    - [Functions](index.md#Functions-1)
    - [Index](index.md#Index-1)


<a id='Functions-1'></a>

## Functions

<a id='IssueReporter.package_uri-Tuple{String}' href='#IssueReporter.package_uri-Tuple{String}'>#</a>
**`IssueReporter.package_uri`** &mdash; *Method*.



```julia
package_uri(package_name)

```

Takes the name of a METADATA Julia package and returns the associated git URL.

#Examples `jldoctest julia> IssueReporter.package_uri("Trie") "git://github.com/JuliaArchive/Trie.jl.git"``


<a target='_blank' href='https://github.com/essenciary/IssueReporter.jl/blob/a8c5936fb2f1012c4f20759e45bf37120042ba5d/src/IssueReporter.jl#L5' class='documenter-source'>source</a><br>

<a id='IssueReporter.token_is_defined-Tuple{}' href='#IssueReporter.token_is_defined-Tuple{}'>#</a>
**`IssueReporter.token_is_defined`** &mdash; *Method*.



```julia
token_is_defined()

```

Checks if the required GitHub authentication token is defined.


<a target='_blank' href='https://github.com/essenciary/IssueReporter.jl/blob/a8c5936fb2f1012c4f20759e45bf37120042ba5d/src/IssueReporter.jl#L21' class='documenter-source'>source</a><br>

<a id='IssueReporter.token-Tuple{}' href='#IssueReporter.token-Tuple{}'>#</a>
**`IssueReporter.token`** &mdash; *Method*.



```julia
token()

```

Returns the configured GitHub authentication token, if defined – or throws an error otherwise.


<a target='_blank' href='https://github.com/essenciary/IssueReporter.jl/blob/a8c5936fb2f1012c4f20759e45bf37120042ba5d/src/IssueReporter.jl#L37' class='documenter-source'>source</a><br>

<a id='IssueReporter.configure-Tuple{String}' href='#IssueReporter.configure-Tuple{String}'>#</a>
**`IssueReporter.configure`** &mdash; *Method*.



```julia
configure(token)

```

Accepts a GitHub authentication token and stores it in the `secrets.jl` configuration file. The `secrets.jl` file is added to `.gitignore` so it won't be accidentally commited.


<a target='_blank' href='https://github.com/essenciary/IssueReporter.jl/blob/a8c5936fb2f1012c4f20759e45bf37120042ba5d/src/IssueReporter.jl#L48' class='documenter-source'>source</a><br>

<a id='IssueReporter.github_auth-Tuple{}' href='#IssueReporter.github_auth-Tuple{}'>#</a>
**`IssueReporter.github_auth`** &mdash; *Method*.



```julia
github_auth()

```

Performs GitHub authentication and returns the OAuth2 object, required by further GitHub API calls.


<a target='_blank' href='https://github.com/essenciary/IssueReporter.jl/blob/a8c5936fb2f1012c4f20759e45bf37120042ba5d/src/IssueReporter.jl#L61' class='documenter-source'>source</a><br>

<a id='IssueReporter.repo_id-Tuple{String}' href='#IssueReporter.repo_id-Tuple{String}'>#</a>
**`IssueReporter.repo_id`** &mdash; *Method*.



```julia
repo_id(package_name)

```

Converts a registered Julia package name to the corresponding GitHub "username/repo_name" string.

#Examples `jldoctest julia> IssueReporter.repo_id("Trie") "JuliaArchive/Trie.jl"``


<a target='_blank' href='https://github.com/essenciary/IssueReporter.jl/blob/a8c5936fb2f1012c4f20759e45bf37120042ba5d/src/IssueReporter.jl#L71' class='documenter-source'>source</a><br>

<a id='IssueReporter.report-Tuple{String,String,String}' href='#IssueReporter.report-Tuple{String,String,String}'>#</a>
**`IssueReporter.report`** &mdash; *Method*.



```julia
report(package_name, title, body)

```

Creates a new GitHub issue with the title `title` and the content `body` onto the repo corresponding to the registered package called `package_name`.


<a target='_blank' href='https://github.com/essenciary/IssueReporter.jl/blob/a8c5936fb2f1012c4f20759e45bf37120042ba5d/src/IssueReporter.jl#L90' class='documenter-source'>source</a><br>


<a id='Index-1'></a>

## Index

- [`IssueReporter.configure`](index.md#IssueReporter.configure-Tuple{String})
- [`IssueReporter.github_auth`](index.md#IssueReporter.github_auth-Tuple{})
- [`IssueReporter.package_uri`](index.md#IssueReporter.package_uri-Tuple{String})
- [`IssueReporter.repo_id`](index.md#IssueReporter.repo_id-Tuple{String})
- [`IssueReporter.report`](index.md#IssueReporter.report-Tuple{String,String,String})
- [`IssueReporter.token`](index.md#IssueReporter.token-Tuple{})
- [`IssueReporter.token_is_defined`](index.md#IssueReporter.token_is_defined-Tuple{})

