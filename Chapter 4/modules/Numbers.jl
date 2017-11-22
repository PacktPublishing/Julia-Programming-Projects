module Numbers

export half_rand

const MY_NAME = "Numbers"

function rand()
  Base.Random.rand(1:1_000)
end

function half_rand()
  floor(rand() / 2) |> Int
end

include("module_name.jl")

end