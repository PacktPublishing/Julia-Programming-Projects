using CSV, DataFrames

const minimum_similarity = 0.8
const movies = CSV.read("top_10_movies_user_rankings.tsv", delim = '\t')

function user_similarity(target_user)
  similarity = Dict{Symbol,Float64}()

  for user in names(movies[:, 2:end])
    user == target_user && continue
    ratings = movies[:, [user, target_user]]
    common_movies = ratings[Array(ratings[user] .>= 0) .& Array(ratings[target_user] .> 0), :]

    correlation = try
      cor(Array(common_movies[user]), Array(common_movies[target_user]))
    catch
      0.0
    end

    similarity[user] = correlation # Dict(:Comey=>1.0,:Dean=>-0.907841,:Missie=>NaN,:Kit=>0.774597,:Musk=>0.797512,:Sam=>0.0,:Acton=>0.632456)
  end

  # println("$target_user $similarity")
  similarity
end

function recommendations(target_user)
  recommended = Dict{String,Float64}()

  for (user,similarity) in user_similarity(target_user)
    similarity > minimum_similarity || continue

    ratings = movies[:, [Symbol("Movie title"), user, target_user]]
    recommended_movies = ratings[Array(ratings[user] .>= 7) .& Array(ratings[target_user] .== 0), :]

    for movie in eachrow(recommended_movies)
      recommended[get(movie[Symbol("Movie title")])] = get(movie[user]) * similarity
    end
  end

  recommended
end

for user in ["Acton", "Annie", "Comey", "Dean", "Kit", "Missie", "Musk", "Sam"]
  println("Recommendations for $user: $(recommendations(Symbol(user)))")
end