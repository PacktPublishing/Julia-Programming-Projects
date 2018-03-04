using IssueReporter
using Base.Test
using URIParser, GitHub

delete!(ENV, "GITHUB_ACCESS_TOKEN")
secrets_path = joinpath(Pkg.dir("IssueReporter"), "secrets.jl")
isfile(secrets_path) && mv(secrets_path, secrets_path * "_")

@testset "Basic features" begin
  @testset "Looking up an existing package returns a proper repo URI" begin
    @test IssueReporter.package_uri("DataFrames") |> URIParser.isvalid
  end

  @testset "Looking up a non-existent package should throw an error" begin
    @test_throws ErrorException IssueReporter.package_uri("DataFramess")
  end
end

@testset "GitHub integration" begin
  @testset "An undefined token should return false" begin
    @test ! IssueReporter.token_is_defined()
  end

  @testset "Attempting to access a token that is not set will error" begin
    @test_throws ErrorException IssueReporter.token()
  end

  # setup a mock token
  ENV["GITHUB_ACCESS_TOKEN"] = "1234"

  @testset "Token is defined" begin
    @test IssueReporter.token_is_defined()
  end

  @testset "A valid token is a non empty string and has the set value" begin
    token = IssueReporter.token()
    @test isa(token, String) && ! isempty(token)
    @test token == "1234"
  end

  delete!(ENV, "GITHUB_ACCESS_TOKEN")
  open(secrets_path, "w") do io
    write(io, """ENV["GITHUB_ACCESS_TOKEN"] = "1234" """)
  end

  @testset "Token is loaded from the `secrets.jl` file" begin
    @test IssueReporter.token_is_defined()
    @test IssueReporter.token() == "1234"
  end

  rm(secrets_path)

  @testset "The configure method writes the token to the secrets file" begin
    IssueReporter.configure("1234")
    @test readline(secrets_path) == """ENV["GITHUB_ACCESS_TOKEN"] = "1234" """
    rm(secrets_path)
  end
end

isfile(secrets_path * "_") && mv(secrets_path * "_", secrets_path)

delete!(ENV, "GITHUB_ACCESS_TOKEN")
@testset "Adding GitHub issues" begin
  @testset "Successful authentication should return a GitHub.OAuth2 instance" begin
    @test_skip isa(IssueReporter.github_auth(), GitHub.OAuth2)
  end
  @testset "Converting package name to GitHub id" begin
    @test IssueReporter.repo_id("Trie") == "JuliaArchive/Trie.jl"
  end
  @testset "Submitting an issue should result in a GitHub.Issue object" begin
    @test_skip isa(IssueReporter.report("Trie", "I found a bug", "Here is how you can reproduce the problem: ..."), GitHub.Issue)
  end
end