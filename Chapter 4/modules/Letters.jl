module Letters

export rand_string

const MY_NAME = "Letters"

function rand()
  Base.Random.rand('A':'Z')
end

function rand_string()
  [string(rand()) for _ in 1:10] |> join
end

include("module_name.jl")

include("Numbers.jl")

end