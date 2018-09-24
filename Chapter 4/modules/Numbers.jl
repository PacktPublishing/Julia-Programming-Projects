module Numbers

using Random

export halfrand

const MY_NAME = "Numbers"

function rand()
  Random.rand(1:1_000)
end

function halfrand()
  floor(rand() / 2)
end

include("module_name.jl")

end
