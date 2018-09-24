using Pkg
pkg"activate ."

include("Database.jl")
include("Wikipedia.jl")
include("Gameplay.jl")

using .Wikipedia, .Gameplay

articles = newgame(Gameplay.DIFFICULTY_EASY)

for article in articles
  println(article.title)
end
