module WebApp

using HTTP, Sockets
using ..Gameplay, ..GameSession, ..Wikipedia, ..Wikipedia.Articles

# Configuration
const HOST = ip"0.0.0.0"
const PORT = 8888
const ROUTER = HTTP.Router()
const SERVER = HTTP.Server(ROUTER)

# Functions
function wikiarticle(game, article)
  html = """
  <!DOCTYPE html>
  <html>
  $(head())

  <body>
    $(objective(game))
    <hr/>
    $(
      if losinggame(game)
        "<h1>You Lost :( </h1>"
      else
        puzzlesolved(game, article) ? "<h1>You Won!</h1>" : ""
      end
    )

    <h1>$(article.title)</h1>
    <div id="wiki-article">
      $(replace(article.content, "/wiki/"=>"/$(game.id)/wiki/"))
    </div>
  </body>
  </html>
  """
end

function history(game)
  html = """<ol class="list-group">"""
  iter = 0
  for a in game.history
    html *= """
      <li class="list-group-item">
        <a href="/$(game.id)/back/$(iter + 1)">$(a.title)</a>
      </li>
    """
    iter += 1
  end

  html * "</ol>"
end

function objective(game)
  """
  <div class="jumbotron">
    <h3>Go from
      <span class="badge badge-info">$(game.articles[1].title)</span>
      to
      <span class="badge badge-info">$(game.articles[end].title)</span>
    </h3>
    <hr/>
    <h5>
      Progress:
      <span class="badge badge-dark">$(size(game.history, 1) - 1)</span>
      out of maximum
      <span class="badge badge-dark">$(size(game.articles, 1) - 1)</span>
      links in
      <span class="badge badge-dark">$(game.steps_taken)</span>
      steps
    </h5>
    $(history(game))
    <hr/>
    <h6>
      <a href="/$(game.id)/solution" class="btn btn-primary btn-lg">Solution?</a> |
      <a href="/" class="btn btn-primary btn-lg">New game</a>
    </h6>
  </div>
  """
end

function head()
  """
  <head>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <title>6 Degrees of Wikipedia</title>
  </head>
  """
end

function puzzlesolved(game, article)
  article.url == game.articles[end].url
end

function losinggame(game)
  game.steps_taken >= Gameplay.MAX_NUMBER_OF_STEPS
end

function parseuri(uri)
  map(x -> String(x), split(uri, "/", keepempty = false))
end


# Routes handlers
const landingpage = HTTP.HandlerFunction() do req
  html = """
  <!DOCTYPE html>
  <html>
  $(head())

  <body>
    <div class="jumbotron">
      <h1>Six degrees of Wikipedia</h1>
      <p>
        The goal of the game is to find the shortest path between two random Wikipedia articles.<br/>
        Depending on the difficulty level you choose, the Wiki pages will be further apart and less related.<br/>
        If you can’t find the solution, you can always go back up the articles chain, but you need to find the solution within the maximum number of steps, otherwise you lose.<br/>
        If you get stuck, you can always check the solution, but you'll lose.<br/>
        Good luck and enjoy!
      </p>

      <hr class="my-4">

      <div>
        <h4>New game</h4>
          <a href="/new/$(Gameplay.DIFFICULTY_EASY)" class="btn btn-primary btn-lg">Easy ($(Gameplay.DIFFICULTY_EASY) links away)</a> |
          <a href="/new/$(Gameplay.DIFFICULTY_MEDIUM)" class="btn btn-primary btn-lg">Medium ($(Gameplay.DIFFICULTY_MEDIUM) links away)</a> |
          <a href="/new/$(Gameplay.DIFFICULTY_HARD)" class="btn btn-primary btn-lg">Hard ($(Gameplay.DIFFICULTY_HARD) links away)</a>
        </div>
    </div>
  </body>
  </html>
  """

  HTTP.Messages.Response(200, html)
end

const newgamepage = HTTP.HandlerFunction() do req
  game = parse(UInt8, (replace(req.target, "/new/"=>""))) |> newgamesession
  article = game.articles[1]
  push!(game.history, article)

  HTTP.Messages.Response(200, wikiarticle(game, article))
end

const articlepage = HTTP.HandlerFunction() do req
  uri_parts = parseuri(req.target)
  game = gamesession(uri_parts[1])
  article_uri = "/wiki/$(uri_parts[end])"

  existing_articles = Articles.find(article_uri)
  article = isempty(existing_articles) ? persistedarticle(fetchpage(article_uri)...) : existing_articles[1]

  push!(game.history, article)
  game.steps_taken += 1

  puzzlesolved(game, article) && destroygamesession(game.id)

  HTTP.Messages.Response(200, wikiarticle(game, article))
end

const backpage = HTTP.HandlerFunction() do req
  uri_parts = parseuri(req.target)
  game = gamesession(uri_parts[1])
  history_index = parse(UInt8, uri_parts[end])

  article = game.history[history_index]
  game.history = game.history[1:history_index]

  HTTP.Messages.Response(200, wikiarticle(game, article))
end

const solutionpage = HTTP.HandlerFunction() do req
  uri_parts = parseuri(req.target)
  game = gamesession(uri_parts[1])
  game.history = game.articles
  game.steps_taken = Gameplay.MAX_NUMBER_OF_STEPS
  article = game.articles[end]

  HTTP.Messages.Response(200, wikiarticle(game, article))
end

const notfoundpage = HTTP.HandlerFunction() do req
  HTTP.Messages.Response(404, "Sorry, this can't be found")
end

# Routes definitions
HTTP.register!(ROUTER, "/", landingpage) # root page
HTTP.register!(ROUTER, "/new/*", newgamepage) # /new/$difficulty_level -- new game
HTTP.register!(ROUTER, "/*/wiki/*", articlepage) # /$session_id/wiki/$wikipedia_article_url -- article page
HTTP.register!(ROUTER, "/*/back/*", backpage) # /$session_id/back/$number_of_steps -- go back the navigation history
HTTP.register!(ROUTER, "/*/solution", solutionpage) # /$session_id/solution -- display the solution
HTTP.register!(ROUTER, "*", notfoundpage) # everything else -- not found

# Start server
HTTP.serve(SERVER, HOST, PORT)

end
