using CSV, DataFrames, Statistics

const minimum_similarity = 0.8
const movies = CSV.read("top_10_movies_user_rankings.tsv", delim = '\t')

function user_similarity(target_user)
  similarity = Dict{Symbol,Float64}()

  for user in names(movies[:, 2:end])
    user == target_user && continue

    ratings = movies[:, [user, target_user]]
    common_movies = ratings[(ratings[user] .> 0) .& (ratings[target_user] .> 0), :]
    # common_movies = ratings[(ratings[user] .> 7) .& (ratings[target_user] .> 0), :]

    correlation = try
      cor(common_movies[user], common_movies[target_user])
    catch
      0.0
    end

    similarity[user] = correlation
  end

  similarity
end

function recommendations(target_user)
  recommended = Dict{String,Float64}()

  for (user,similarity) in user_similarity(target_user)
    similarity > minimum_similarity || continue

    ratings = movies[:, [Symbol("Movie title"), user, target_user]]
    recommended_movies = ratings[(ratings[user] .>= 7) .& (ratings[target_user] .== 0), :]

    for movie in eachrow(recommended_movies)
      recommended[movie[Symbol("Movie title")]] = movie[user] * similarity
    end
  end

  recommended
end

for user in names(movies)[2:end]
  println("Recommendations for $user: $(recommendations(user))")
end