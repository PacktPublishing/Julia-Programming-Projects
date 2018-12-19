# IssueReporter.jl

`IssueReporter.jl` is a Julia package which makes it easy to report a new issue with a registered package.
In order to use it, it needs to be configured with a valid GitHub authenti-cation token. Follow the instructions at
https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/ to generate a new token -- make sure
that it has the `repo` access.

Once you have the token, add it to the secrets.jl file.

You can now open issues by invoking:
`IssueReporter.report("Julia package name", "issue title", "issue body")
