module Gameplay

using ..Wikipedia, ..Wikipedia.Articles

export newgame

const DIFFICULTY_EASY = 2
const DIFFICULTY_MEDIUM = 4
const DIFFICULTY_HARD = 6

function newgame(difficulty = DIFFICULTY_HARD)
  articles = Article[]

  for i in 1:difficulty+1
    article = if i == 1
                article = persistedarticle(fetchrandom()...)
              else
                url = rand(articles[i-1].links)
                existing_articles = Articles.find(url)

                article = isempty(existing_articles) ? persistedarticle(fetchpage(url)...) : existing_articles[1]
              end

    push!(articles, article)
  end

  articles
end

end
