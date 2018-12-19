module GameSession

using ..Gameplay, ..Wikipedia, ..Wikipedia.Articles
using Random

mutable struct Game
  id::String
  articles::Vector{Article}
  history::Vector{Article}
  steps_taken::UInt8
  difficulty::UInt8

  Game(game_difficulty) = new(randstring(), newgame(game_difficulty), Article[], 0, game_difficulty)
end

const GAMES = Dict{String,Game}()

export newgamesession, gamesession, destroygamesession

function newgamesession(difficulty)
  game = Game(difficulty)
  GAMES[game.id] = game

  game
end

function gamesession(id)
  GAMES[id]
end

function destroygamesession(id)
  delete!(GAMES, id)
end

end
