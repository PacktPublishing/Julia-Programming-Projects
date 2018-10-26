using CSV, DataFrames, DelimitedFiles, Statistics

const minimum_similarity = 0.8

function setup_data()
  movies = readdlm("top_10_movies_user_rankings.tsv", '\t')
  movies = permutedims(movies, (2,1))
  movies = convert(DataFrame, movies)

  names = convert(Array, movies[1, :])[1,:]

  names!(movies, [Symbol(name) for name in names])
  deleterows!(movies, 1)
  rename!(movies, [Symbol("Movie title") => :User])
end

function movie_similarity(target_movie)
  similarity = Dict{Symbol,Float64}()

  for movie in names(movies[:, 2:end])
    movie == target_movie && continue
    ratings = movies[:, [movie, target_movie]]

    common_users = ratings[(ratings[movie] .>= 0) .& (ratings[target_movie] .> 0), :]

    correlation = try
      cor(common_users[movie], common_users[target_movie])
    catch
      0.0
    end

    similarity[movie] = correlation
  end

  # println("The movie $target_movie is similar to $similarity")
  similarity
end

function recommendations(target_movie)
  recommended = Dict{String,Vector{Tuple{String,Float64}}}()

  # @show target_movie
  # @show movie_similarity(target_movie)

  for (movie, similarity) in movie_similarity(target_movie)
    movie == target_movie && continue
    similarity > minimum_similarity || continue

    # println("Checking to which users we can recommend $movie")

    recommended["$movie"] = Vector{Tuple{String,Float64}}()

    for user_row in eachrow(movies)
      if user_row[target_movie] >= 5
        # println("$(user_row[:User]) has watched $target_movie so we can recommend similar movies")

        if user_row[movie] == 0
          # println("$(user_row[:User]) has not watched $movie so we can recommend it")
          # println("Recommending $(user_row[:User]) the movie $movie")

          push!(recommended["$movie"], (user_row[:User], user_row[target_movie] * similarity))
        end
      end
    end
  end

  recommended
end

const movies = setup_data()
println("Recommendations for users that watched Finding Dory (2016): $(recommendations(Symbol("Finding Dory (2016)")))")