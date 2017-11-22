module Gameplay

using Wikipedia, Wikipedia.Articles

export new_game

const DIFFICULTY_EASY = 2
const DIFFICULTY_MEDIUM = 4
const DIFFICULTY_HARD = 6

function new_game(difficulty = DIFFICULTY_HARD)
  articles = Article[]
  
  for i in 1:difficulty+1
    if i == 1
      article = persisted_article(fetch_random()...)
    else 
      url = rand(articles[i-1].links)
      existing_articles = Articles.find(url)

      article = isempty(existing_articles) ? persisted_article(fetch_page(url)...) : existing_articles[1]
    end
    
    push!(articles, article)
  end

  articles
end



end