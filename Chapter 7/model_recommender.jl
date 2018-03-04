module ModelRecommender

using CSV, DataFrames, Recommendation

const training_data = CSV.read("data/training.dat")
const gender_data = CSV.read("data/libimseti/gender.dat", header = false)

const user_mappings, profile_mappings = Dict{Int,Int}(), Dict{Int,Int}()
user_counter, profile_counter = 0, 0

const MAXITER = 10
const MAXRECS = 20

export recsys, recommend_profiles

function data_accessor() :: DataAccessor
  global user_counter, profile_counter
  events = Event[]

  for row in eachrow(training_data)
    user_id, profile_id, rating = row[:UserID], row[:ProfileID], row[:Rating]
    haskey(user_mappings, user_id) || (user_mappings[user_id] = (user_counter += 1))
    haskey(profile_mappings, profile_id) || (profile_mappings[profile_id] = (profile_counter += 1))
    push!(events, Event(user_mappings[user_id], profile_mappings[profile_id], rating))
  end

  DataAccessor(events, user_counter, profile_counter)
end

function recsys() :: Recommender
  r = MF(data_accessor())
  println("Training recommender...")
  build(r, max_iter = MAXITER)

  r
end

function make_recommendations(r::Recommender, rec_user_id, max_recs = MAXRECS, max_profiles = profile_counter)
  recommend(r, rec_user_id, max_recs, [1:max_profiles...]) |> recommendations_to_profiles
end

function reverse_dict(d)
  Dict(value => key for (key, value) in d)
end

function recommendations_to_profiles(recommendations)
  [reverse_dict(profile_mappings)[r[1]] for r in recommendations]
end

function user_gender_prefs(user_id)
  user_ratings = training_data[training_data[:UserID] .== user_id, :ProfileID]
  unique(gender_data[[in(pid, user_ratings) for pid in gender_data[:Column1]], :Column2])
end

function filter_by_gender(recommendations, gender_prefs)
  length(gender_prefs) > 1 && return recommendations

  recommendations_gender = gender_data[[in(r, recommendations) for r in gender_data[:Column1]], :]
  recommendations_gender[[in(g, gender_prefs) for g in recommendations_gender[:Column2]], :Column1]
end

function recommend_profiles(r::Recommender, user_id, nr_of_recommendations = MAXRECS)
  recommendations = make_recommendations(r, user_mappings[user_id], nr_of_recommendations)
  filter_by_gender(recommendations, user_gender_prefs(user_id))
end

end

using ModelRecommender

r = recsys()
@show recommend_profiles(r, 134)