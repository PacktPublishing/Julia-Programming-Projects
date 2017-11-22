push!(LOAD_PATH, ".")

using Wikipedia, Gameplay

for article in new_game(Gameplay.DIFFICULTY_EASY)
  println(article.title)
end