var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "IssueReporter.jl Documentation",
    "title": "IssueReporter.jl Documentation",
    "category": "page",
    "text": ""
},

{
    "location": "#IssueReporter.jl-Documentation-1",
    "page": "IssueReporter.jl Documentation",
    "title": "IssueReporter.jl Documentation",
    "category": "section",
    "text": "CurrentModule = IssueReporter"
},

{
    "location": "#IssueReporter.packageuri-Tuple{String}",
    "page": "IssueReporter.jl Documentation",
    "title": "IssueReporter.packageuri",
    "category": "method",
    "text": "packageuri(pkgname)\n\n\nTakes the name of a registered Julia package and returns the associated repo git URL.\n\nExamples\n\njulia> IssueReporter.packageuri(\"IssueReporter\")\n\"git://github.com/essenciary/IssueReporter.jl.git\"\n\n\n\n\n\n"
},

{
    "location": "#IssueReporter.tokenisdefined-Tuple{}",
    "page": "IssueReporter.jl Documentation",
    "title": "IssueReporter.tokenisdefined",
    "category": "method",
    "text": "tokenisdefined()\n\n\nChecks if the required GitHub authentication token is defined.\n\n\n\n\n\n"
},

{
    "location": "#IssueReporter.token-Tuple{}",
    "page": "IssueReporter.jl Documentation",
    "title": "IssueReporter.token",
    "category": "method",
    "text": "token()\n\n\nReturns the configured GitHub authentication token, if defined – or throws an error otherwise.\n\n\n\n\n\n"
},

{
    "location": "#IssueReporter.githubauth-Tuple{}",
    "page": "IssueReporter.jl Documentation",
    "title": "IssueReporter.githubauth",
    "category": "method",
    "text": "githubauth()\n\n\nPerforms GitHub authentication and returns the OAuth2 object, required by further GitHub API calls.\n\n\n\n\n\n"
},

{
    "location": "#IssueReporter.repoid-Tuple{String}",
    "page": "IssueReporter.jl Documentation",
    "title": "IssueReporter.repoid",
    "category": "method",
    "text": "repoid(package_name)\n\n\nConverts a registered Julia package name to the corresponding GitHub \"username/repo_name\" string.\n\nExamples\n\njulia> IssueReporter.repoid(\"IssueReporter\")\n\"essenciary/IssueReporter.jl\"\n\n\n\n\n\n"
},

{
    "location": "#IssueReporter.report-Tuple{String,String,String}",
    "page": "IssueReporter.jl Documentation",
    "title": "IssueReporter.report",
    "category": "method",
    "text": "report(package_name, title, body)\n\n\nCreates a new GitHub issue with the title title and the content body onto the repo corresponding to the registered package called pack-age_name.\n\n\n\n\n\n"
},

{
    "location": "#Functions-1",
    "page": "IssueReporter.jl Documentation",
    "title": "Functions",
    "category": "section",
    "text": "packageuri(pkgname::String)\ntokenisdefined()\ntoken()\ngithubauth()\nrepoid(package_name::String)\nreport(package_name::String, title::String, body::String)"
},

{
    "location": "#Index-1",
    "page": "IssueReporter.jl Documentation",
    "title": "Index",
    "category": "section",
    "text": ""
},

]}
